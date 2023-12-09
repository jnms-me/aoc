/+dub.sdl:
+/
import std;

/// Source: https://rosettacode.org/wiki/Combinations#D
T[][] combinations(T)(in T[] arr, in int k) pure nothrow
{
    if (k == 0)
        return [[]];
    typeof(return) result;
    foreach (immutable i, immutable x; arr)
        foreach (suffix; arr[i + 1 .. $].combinations(k - 1))
            result ~= x ~ suffix;
    return result;
}

static immutable string cardOrder = "J23456789TQKA";

struct Card
{
    byte orderIndex;

    this(dchar c)
    {
        long i = cardOrder.countUntil(c);
        assert(i != -1);
        this.orderIndex = cast(byte) i;
    }
}

enum HandType : int
{
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind
}

struct Hand
{
    Card[] cards;
    int[Card] cardFrequencies;
    int bid;

    this(string s)
    {
        string cardsString;
        s.formattedRead!"%s %d"(cardsString, bid);
        assert(cardsString.length == 5);
        assert(bid >= 0);

        cards = cardsString.map!Card.array;
        foreach (card; cards)
            cardFrequencies[card]++;
    }

    HandType type() const
    {
        HandType _type(const int[Card] cardFrequencies)
        {
            switch (cardFrequencies.length) with (HandType)
            {
            case 1:
                return FiveOfAKind;
            case 2:
                if (cardFrequencies.values.canFind(4))
                    return FourOfAKind;
                else
                    return FullHouse;
            case 3:
                if (cardFrequencies.values.canFind(3))
                    return ThreeOfAKind;
                else
                    return TwoPair;
            case 4:
                return OnePair;
            case 5:
                return HighCard;
            default:
                assert(false, "Unknown hand type");
            }
        }

        // If there are jokers, try replacing the jokers with all combinations of the
        // same amount of cards, limited to the types found in this hand (including joker).
        // Return the highest result.
        enum Joker = Card('J');
        if (Joker in cardFrequencies)
        {
            int jokerCount = cardFrequencies[Joker];

            int[Card] cardFrequenciesWithoutJokers = cast(int[Card]) cardFrequencies.dup;
            cardFrequenciesWithoutJokers.remove(Joker);

            HandType best = HandType.HighCard;

            auto jokersReplacements = cardFrequencies
                .keys
                .repeat(jokerCount).join
                .combinations(jokerCount)
                .sort.uniq;
            foreach (Card[] jokersReplacement; jokersReplacements)
            {
                int[Card] tempCardFrequencies = cardFrequenciesWithoutJokers.dup;
                foreach (card; jokersReplacement)
                    tempCardFrequencies[card]++;
                HandType result = _type(tempCardFrequencies);
                best = max(best, result);
            }
            return best;
        }
        else
            return _type(cardFrequencies);
    }

    int opCmp(const Hand other) const
    {
        int diff = cast(int) type - cast(int) other.type;
        if (diff == 0)
        {
            foreach (card, othersCard; zip(cards, other.cards))
            {
                diff = card.orderIndex - othersCard.orderIndex;
                if (diff != 0)
                    break;
            }
        }
        return diff;
    }
}

void main()
{
    // Parse input as Hand structs
    Hand[] hands = stdin
        .byLine
        .map!(to!string)
        .map!Hand
        .array;

    // Sort using Hand.opCmp, from least to most worth
    hands.sort;

    debug foreach (i, h; hands)
        writefln!"%d: %s %s"(i + 1, h.type, h);

    // Calculate winnings
    Checked!long winnings;
    foreach (i, hand; hands)
    {
        int rank = cast(int) i + 1;
        winnings += hand.bid * rank;
    }

    writeln(winnings.get);
}
