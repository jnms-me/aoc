/+dub.sdl:
+/
import std;

int[int] readCard(string s)
{
    int id; string ourNumbersString; string winningNumbersString;
    s.formattedRead!"Card %d: %s| %s"(id, ourNumbersString, winningNumbersString);

    int[int] result;

    foreach(numbersString; [ourNumbersString, winningNumbersString])
        foreach(numberString; numbersString.split(" "))
            if (numberString.length)
                result[numberString.to!int]++;
    
    return result;
}

int calculateCardWorth(int[int] card)
{
    int[] counts = card.values;
    counts[] -= 1;
    int matches = counts.sum;
    int worth = 2 ^^ (matches - 1);
    return worth;
}

void main()
{
    stdin
        .byLine
        .map!(to!string)
        .map!readCard
        .map!calculateCardWorth
        .sum
        .writeln;
}
