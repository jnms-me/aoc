/+dub.sdl:
+/
import std;

int[int] readCombinedNumberCountsFromCard(string s)
{
    int id;
    string ourNumbersString;
    string winningNumbersString;
    s.formattedRead!"Card %d: %s| %s"(id, ourNumbersString, winningNumbersString);

    int[int] result;

    foreach (numbersString; [ourNumbersString, winningNumbersString])
        foreach (numberString; numbersString.split(" "))
            if (numberString.length)
                result[numberString.to!int]++;

    return result;
}

int calculateMatchCount(int[int] card)
{
    int[] counts = card.values;
    counts[] -= 1;
    int matches = counts.sum;
    return matches;
}

void main()
{
    struct CardStack
    {
        int stackSize;
        int matchCount;
    }

    CardStack[] cardStacks = stdin
        .byLine
        .map!(to!string)
        .map!readCombinedNumberCountsFromCard         // Parses a card string as a int[int] of number counts
        .map!calculateMatchCount                      // Calculates amount of matching numbers
        .map!(matchCount => CardStack(1, matchCount)) // Creates a CardStack of size 1 for each card
        .array;

    // Iterate once over the stacks to receive our card copies
    foreach (i, ref CardStack cardStack; cardStacks)
        // Win `stackSize` cards of each `matchCount` next cards
        foreach (j; i + 1 .. i + 1 + cardStack.matchCount)
            cardStacks[j].stackSize += cardStack.stackSize;
    
    cardStacks
        .map!(cardStack => cardStack.stackSize)
        .sum
        .writeln;
}
