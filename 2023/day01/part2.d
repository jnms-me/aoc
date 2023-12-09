/+dub.sdl:
dependency "pegged" version="~>0.4.9"
+/
import std;

static immutable string[] englishDigits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
static immutable string[] englishDigitsReverse = englishDigits.map!(s => s.dup.reverse).array;

static immutable digitsRegex = ctRegex!("[0-9]|" ~ englishDigits.join("|"));
static immutable digitsReverseRegex = ctRegex!("[0-9]|" ~ englishDigitsReverse.join("|"));

string findFirstDigit(string s, bool reverse)
{
    if (reverse) s = s.dup.reverse;
    auto r = reverse ? digitsReverseRegex : digitsRegex;
    auto match = s.matchFirst(r);
    return match.hit;
}

string replaceEnglishDigit(string s, bool reverse)
{
    auto digits = reverse ? englishDigitsReverse : englishDigits;
    foreach (i, digit; digits)
        if (s == digit)
            return (i + 1).to!string;
    return s;
}

void main()
{
    stdin
        .byLine
        .map!(to!string)
        .map!(s => tuple( // Find the first and last literal or written english digit
            s.findFirstDigit(reverse:false),
            s.findFirstDigit(reverse:true)
        ))
        .map!(t => tuple( // Replace any wrtten english digits with literal digits
            t[0].replaceEnglishDigit(reverse:false),
            t[1].replaceEnglishDigit(reverse:true)
        ))
        .map!(t => t[0].to!int * 10 + t[1].to!int) // Interpret the 2 digits as an integer
        .sum
        .writeln;
}
