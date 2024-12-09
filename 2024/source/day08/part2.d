module day08.part2;

import std.algorithm : cartesianProduct;
import std.format : formattedRead;
import std.range : enumerate, walkLength;
import std.stdio : stdin, writeln;

void solve()
{
    struct Vec2
    {
        long x, y;

        typeof(this) opBinary(string op)(const typeof(this) rhs) const
        {
            return typeof(this)(
                mixin("x" ~ op ~ "rhs.x"),
                mixin("y" ~ op ~ "rhs.y"),
            );
        }

        typeof(this) opOpAssign(string op)(const typeof(this) rhs)
        {
            x = mixin("x" ~ op ~ "rhs.x");
            y = mixin("y" ~ op ~ "rhs.y");
            return this;
        }
    }

    long width, height;
    bool[Vec2][dchar] antennaPerFreq;
    foreach (y, char[] line; stdin.byLine.enumerate)
    {
        if (!width)
            width = line.length;
        height++;
        foreach (x, dchar c; line)
            if (c != '.')
                antennaPerFreq[c][Vec2(x, y)] = true;
    }

    bool inMap(Vec2 v)
    {
        return 0 <= v.x && v.x < width
            && 0 <= v.y && v.y < height;
    }

    bool[Vec2] antinodes;
    foreach (dchar freq, bool[Vec2] antennas; antennaPerFreq)
        foreach (pair; cartesianProduct(antennas.byKey, antennas.byKey))
            if (pair[0] != pair[1])
            {
                Vec2 antinode = pair[0];
                while (inMap(antinode))
                {
                    antinodes[antinode] = true;
                    antinode += pair[0] - pair[1];
                }
            }

    antinodes.byKey.walkLength.writeln;
}
