module day01.part2;

import std.format : formattedRead;
import std.stdio : stdin, writeln;

void solve()
{
    uint[uint] freq1, freq2;
    foreach (line; stdin.byLine)
    {
        uint id1, id2;
        line.formattedRead!"%d   %d"(id1, id2);
        freq1[id1]++;
        freq2[id2]++;
    }
    ulong score;
    foreach(id, freq; freq1)
        if (id in freq2)
            score += id * freq * freq2[id];
    score.writeln;
}