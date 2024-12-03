module day03.part1;

import std.algorithm : map, sum;
import std.array : join;
import std.format : formattedRead;
import std.regex : ctRegex, matchAll;
import std.stdio : stdin, writeln;

void solve()
{
    stdin
        .byLine
        .join
        .matchAll(ctRegex!`mul\([0-9]+,[0-9]+\)`)
        .map!((match) pure {
            long a, b;
            match.hit.formattedRead!"mul(%d,%d)"(a, b);
            return a * b;
        })
        .sum
        .writeln;
}
