/+dub.sdl:
+/
import std;

dchar firstDigit(S)(S s) => s.find!isNumber.front;

void main()
{
    stdin
        .byLine
        .map!(s => [s.firstDigit, s.retro.firstDigit])
        .map!(to!int)
        .sum
        .writeln;
}
