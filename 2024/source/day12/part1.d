module day12.part1;

import std.algorithm : map, sum;
import std.exception : enforce;
import std.range : enumerate, iota;
import std.stdio : stdin, writeln;

enum size_t size = 140;

void solve()
{
    dchar[size][size] mapInput;
    foreach (y, char[] line; stdin.byLine.enumerate)
    {
        enforce(line.length == size && y < size, "invalid dimensions");
        foreach (x, dchar c; line)
            mapInput[y][x] = c;
    }

    uint[size][size] mapIds;
    uint nextId = 1;
    uint[uint] areaById;
    uint[uint] perimiterById;
    bool rec(const size_t x, const size_t y, const dchar c, const uint id)
    {
        if (x >= size || y >= size)
            return false;
        if (mapIds[y][x] == id)
            return true;
        if (mapIds[y][x] || mapInput[y][x] != c)
            return false;
        mapIds[y][x] = id;
        areaById[id]++;
        perimiterById[id] += 4
            - rec(x + 1, y, c, id)
            - rec(x - 1, y, c, id)
            - rec(x, y + 1, c, id)
            - rec(x, y - 1, c, id);
        return true;
    }
    foreach (y, row; mapInput)
        foreach (x, dchar el; row)
            if (rec(x, y, el, nextId))
                nextId++;

    iota(1, nextId)
        .map!(id => areaById[id] * perimiterById[id])
        .sum
        .writeln;
}
