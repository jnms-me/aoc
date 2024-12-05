module day05.part2;

import std.algorithm : canFind, filter, isSorted, map, sort, sum;
import std.format : formattedRead;
import std.stdio : stdin, writeln;

void solve()
{
    int[][int] mustPrecedeMap;
    int[][] updates;

    bool passedSeparator;
    foreach (line; stdin.byLine)
    {
        if (!line.length)
            passedSeparator = true;
        else if (!passedSeparator)
        {
            int pre, post;
            line.formattedRead!"%d|%d"(pre, post);
            mustPrecedeMap[pre] ~= post;
        }
        else
        {
            int[] update;
            line.formattedRead!"%(%d,%)"(update);
            updates ~= update;
        }
    }

    bool less(const int page1, const int page2)
        => page1 in mustPrecedeMap && mustPrecedeMap[page1].canFind(page2);

    int middlePage(const int[] update)
        => update[$ / 2];

    updates
        .filter!(u => !u.isSorted!less)
        .map!(u => u.sort!less.release)
        .map!middlePage
        .sum
        .writeln;
}
