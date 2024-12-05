module main;

import std.conv : to;
import std.exception : enforce;
import std.format : f = format;

enum uint days = 5;

void main(string[] args)
{
    enforce(args.length == 3, "Usage: ./aoc24 day part");

    const day = args[1].to!uint;
    const part = args[2].to!uint;
    enforce(1 <= day && day <= days, "Invalid day");
    enforce(1 <= part && part <= 2, "Invalid part");

    final switch (day)
    {
        static foreach (eachDay; 1 .. days + 1)
        {
        case eachDay:
            final switch (part)
            {
                static foreach (eachPart; [1, 2])
                {
                case eachPart:
                    imported!(f!"day%02u.part%u"(eachDay, eachPart)).solve;
                    return;
                }
            }
        }
    }
}
