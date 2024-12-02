module day02.part2;

import std.algorithm : any, count, fold, map, splitter;
import std.conv : to;
import std.math : abs;
import std.range : chain, drop, dropOne, slide, take, walkLength;
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

bool tolerateOneErr(R)(R report)
if (isInputRange!R)
{
    if (report.isSafe)
        return true;
    foreach (i; 0 .. report.walkLength)
        if (report.take(i).chain(report.drop(i + 1)).isSafe)
            return true;
    return false;
}

void solve()
{
    stdin.byLine
        .map!(l => l.splitter.map!(to!int))
        .count!(l => l.tolerateOneErr)
        .writeln;
}
