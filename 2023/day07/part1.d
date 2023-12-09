/+dub.sdl:
+/
import std;

static immutable string cardOrder = "23456789TJQKA";

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

    // Calculate winnings
    Checked!long winnings;
    foreach(i, hand; hands)
    {
        int rank = cast(int) i + 1;
        winnings += hand.bid * rank;
    }
    
    writeln(winnings.get);
}
