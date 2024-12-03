module day03.part2;

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
        .matchAll(ctRegex!`(mul\([0-9]+,[0-9]+\)|do\(\)|don't\(\))`)
        .map!((match) {
            static bool doMul = true;
            if (match.hit.length == `do()`.length)
                doMul = true;
            else if (match.hit.length == `don't()`.length)
                doMul = false;
            else if (doMul)
            {
                long a, b;
                match.hit.formattedRead!"mul(%d,%d)"(a, b);
                return a * b;
            }
            return 0;
        })
        .sum
        .writeln;
}
