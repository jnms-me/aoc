module day02.part1;

import std.algorithm : any, count, fold, map, splitter;
import std.conv : to;
import std.math : abs;
import std.range : dropOne, slide, walkLength;
import std.range.primitives : isInputRange;
import std.stdio : stdin, writeln;
import std.traits : isIntegral;

bool sameSign(T)(T a, T b)
if (isIntegral!T)
    => (a < 0 && b < 0) || (0 <= a && 0 <= b);

bool isSafe(R)(R report)
if (isInputRange!R)
{
    auto diffs = report.slide(2).map!(fold!"a-b");
    if (diffs.any!(diff => diff == 0 || abs(diff) > 3))
        return false;
    int firstDiff = diffs.front;
    if (diffs.dropOne.any!(diff => !sameSign(diff, firstDiff)))
        return false;
    return true;
}

void solve()
{
    stdin.byLine
        .map!(l => l.splitter.map!(to!int))
        .count!(l => l.isSafe)
        .writeln;
}
