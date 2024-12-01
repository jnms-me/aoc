module day01.part1;

import std.algorithm : fold, map, sort, sum;
import std.array : array, split;
import std.conv : to;
import std.range : transposed;
import std.stdio : stdin, writeln;

void solve()
{
    stdin.byLine
        .map!(line => line.split.map!(to!int).array).array
        .transposed
        .map!(r => r.array.sort).array
        .transposed
        .map!(fold!"abs(a-b)")
        .sum
        .writeln;
}