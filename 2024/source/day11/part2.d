module day11.part2;

import std.algorithm : map, splitter, sum;
import std.conv : to;
import std.functional : memoize;
import std.math : floor, log10;
import std.stdio : readln, writeln;

void solve()
{
    readln
        .splitter
        .map!(to!long)
        .map!(n => countStones(n, 75))
        .sum
        .writeln;
}

alias countStones = memoize!countStonesImpl;
nothrow
long countStonesImpl(long number, long iterations)
{
    long count, digits, digitsDiv2Exp10;
    if (iterations == 0)
        count = 1;
    else
    {
        iterations -= 1;
        if (number == 0)
            count = countStones(1, iterations);
        else if ((digits = 1 + number.intLog10) % 2 == 0)
        {
            digitsDiv2Exp10 = 10 ^^ (digits / 2);
            count += countStones(number / digitsDiv2Exp10, iterations);
            count += countStones(number % digitsDiv2Exp10, iterations);
        }
        else
            count = countStones(number * 2024, iterations);
    }
    return count;
}

pure nothrow @nogc
long intLog10(long arg)
    => cast(long) log10(cast(double) arg).floor;
