module day06.part1;

import std.format : formattedRead;
import std.range : enumerate;
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
    }

    long mapWidth, mapHeight;
    bool[Vec2] obstaclePositions;
    Vec2 guardPosition;
    Vec2 guardVelocity = Vec2(0, -1);

    foreach (y, line; stdin.byLine.enumerate)
    {
        if (!mapWidth)
            mapWidth = line.length;
        mapHeight++;
        foreach (x, c; line)
        {
            Vec2 pos = Vec2(x, y);
            if (c == '#')
                obstaclePositions[pos] = true;
            else if (c == '^')
                guardPosition = pos;
        }
    }

    bool guardInMap()
    {
        return 0 <= guardPosition.x && guardPosition.x < mapWidth
            && 0 <= guardPosition.y && guardPosition.y < mapHeight;
    }

    bool[Vec2] visited;
    while (guardInMap)
    {
        visited[guardPosition] = true;
        if ((guardPosition + guardVelocity) in obstaclePositions)
        {
            guardVelocity = Vec2(
                -guardVelocity.y,
                guardVelocity.x,
            );
        }
        else
        {
            guardPosition = guardPosition + guardVelocity;
        }
    }
    visited.keys.length.writeln;
}
