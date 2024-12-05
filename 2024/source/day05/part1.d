module day05.part1;

import std.algorithm : canFind, filter, map, sum;
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

    bool validate(const int[] update)
    {
        foreach (i, page; update)
        {
            const int[] previousPages = update[0 .. i];
            if (page in mustPrecedeMap)
            {
                int[] mayNotPrecede = mustPrecedeMap[page];
                foreach (previousPage; previousPages)
                    if (mayNotPrecede.canFind(previousPage))
                        return false;
            }
        }
        return true;
    }

    int middlePage(const int[] update)
        => update[$ / 2];

    updates
        .filter!validate
        .map!middlePage
        .sum
        .writeln;
}
