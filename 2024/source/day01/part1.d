module day01.part1;

import std.algorithm : map, sum;
import std.array : array;
import std.container.binaryheap : BinaryHeap;
import std.format : formattedRead;
import std.math : abs;
import std.range : zip;
import std.stdio : stdin, writeln;

void solve()
{
    int[][2] lists;

    foreach (line; stdin.byLine)
    {
        int[2] ids;
        line.formattedRead!"%d   %d"(ids[0], ids[1]);
        lists[0] ~= ids[0];
        lists[1] ~= ids[1];
    }

    alias Heap = BinaryHeap!(int[]);
    Heap[2] heaps = lists[].map!Heap.array;

    zip(heaps[0], heaps[1])
        .map!(tup => abs(tup[0] - tup[1]))
        .sum
        .writeln;
}
