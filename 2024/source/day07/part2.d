module day07.part2;

import std.algorithm : canFind, filter, map, sum;
import std.conv : to;
import std.format : f = format, formattedRead;
import std.math : floor, log10;
import std.stdio : stdin, writeln;
import std.typecons : tuple;

void solve()
{
    stdin
        .byLine
        .map!((line) {
            long output;
            long[] inputs;
            line.formattedRead!"%d: %(%d %)"(output, inputs);
            return tuple(output, inputs);
        })
        .map!(tup => tuple(tup[0], tup[1].rec))
        .filter!(tup => tup[1].canFind(tup[0]))
        .map!(tup => tup[0])
        .sum
        .writeln;
}

long[] rec(long[] inputs)
in (inputs.length > 0)
{
    if (inputs.length == 1)
        return inputs;

    long[] res;
    long[] lhsArr = inputs[0 .. $ - 1].rec;
    long rhs = inputs[$ - 1];
    foreach (long lhs; lhsArr)
    {
        res ~= lhs + rhs;
        res ~= lhs * rhs;
        // res ~= f!"%d%d"(lhs, rhs).to!long;
        res ~= lhs * 10 ^^ (1 + rhs.intLog10) + rhs;
    }
    return res;
}

pure nothrow @nogc
long intLog10(long arg)
    => cast(long) log10(cast(double) arg).floor;
