/+dub.sdl:
dependency "pegged" version="~>0.4.9"
+/
import std;
import pegged.grammar;

mixin(grammar(`
CalibrationValue:
    Value   < (Digit / Padding)*
    Digit   < [0-9] / "one" / "two" / "three" / "four" / "five" / "six" / "seven" / "eight" / "nine"
    Padding < .
`));

mixin(grammar(`
CalibrationValueReverse:
    Value   < (Digit / Padding)*
    Digit   < [0-9] / "eno" / "owt" / "eerht" / "ruof" / "evif" / "xis" / "neves" / "thgie" / "enin"
    Padding < .
`));

enum EnglishDigits : int        { one = 1, two, three, four, five, six, seven, eight, nine }
enum EnglishDigitsReverse : int { eno = 1, owt, eerht, ruof, evif, xis, neves, thgie, enin }

string replaceEnglishDigit(alias digits)(string s)
{
    foreach (digit; EnumMembers!digits)
        if (equal(s, digit.to!string))
            return digit.to!int.to!string;
    return s;
}

dchar firstDigit(S)(S s) => s.find!isNumber.front;

void main()
{
    stdin
        .byLine
        .map!(s => [      // Parse as grammar elements twice, the second time in reverse
            CalibrationValue(s.to!string).matches,
            CalibrationValueReverse(s.reverse.to!string).matches
        ])
        .map!(p => [      // Replace english digits with single characters
            p[0].map!(replaceEnglishDigit!(EnglishDigits)).array,
            p[1].map!(replaceEnglishDigit!(EnglishDigitsReverse)).array
        ])          
        .map!(map!joiner) // Concatenate the grammar elements
        .map!(p => [      // Select the first & last digits
            p[0].firstDigit,
            p[1].firstDigit
        ]) 
        .map!(to!int)     // Interpret as an integer
        .sum
        .writeln;
}
