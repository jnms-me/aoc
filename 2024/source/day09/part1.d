module day09.part1;

import std.algorithm : swap;
import std.conv : to;
import std.format : formattedRead;
import std.stdio : readln, stdin, writeln;

struct Block
{
    long id;

    bool free() const
        => id == -1;
}

Block[] readDisk()
{
    Block[] disk;
    foreach (i, c; readln)
        foreach (_; 0 .. [c].to!long)
            disk ~= Block(i % 2 == 0 ? i / 2 : -1);
    return disk;
}

void compact(Block[] disk)
{
    Block* l = &disk[0];
    Block* r = &disk[$ - 1];
    while (l < r)
    {
        if (!l.free)
        {
            l++;
            continue;
        }
        if (r.free)
        {
            r--;
            continue;
        }
        swap(*l++, *r--);
    }
}

long checksum(Block[] disk)
{
    long res;
    foreach (i, block; disk)
        if (!block.free)
            res += i * block.id;
    return res;
}

void solve()
{
    Block[] disk = readDisk;
    disk.compact;
    disk.checksum.writeln;
}
