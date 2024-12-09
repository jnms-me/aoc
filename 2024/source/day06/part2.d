module day06.part2;

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

        typeof(this) rotated90Clockwise() const
            => typeof(this)(-y, x);

        typeof(this) rotated90CounterClockwise() const
            => typeof(this)(y, -x);
    }

    long mapWidth, mapHeight;
    bool[Vec2] obstaclePositions;
    Vec2 guardPosition;
    Vec2 guardVelocity = Vec2(0, -1);
    Vec2 guardSight;

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
            {
                guardPosition = pos;
                guardSight = guardPosition + guardVelocity;
            }
        }
    }

    bool guardInMap()
    {
        return 0 <= guardPosition.x && guardPosition.x < mapWidth
            && 0 <= guardPosition.y && guardPosition.y < mapHeight;
    }

    bool checkLoop()
    {
        if (guardPosition == guardSight)
            return false;

        Vec2 saveGuardPosition = guardPosition;
        Vec2 saveGuardVelocity = guardVelocity;
        obstaclePositions[guardPosition + guardVelocity] = true;

        scope (exit)
        {
            guardPosition = saveGuardPosition;
            guardVelocity = saveGuardVelocity;
            obstaclePositions.remove(guardPosition + guardVelocity);
        }

        bool[Vec2][Vec2] visitedByVelocity;
        while (guardInMap)
        {
            while ((guardPosition + guardVelocity) in obstaclePositions)
                guardVelocity = guardVelocity.rotated90Clockwise;
            visitedByVelocity[guardVelocity][guardPosition] = true;
            guardPosition += guardVelocity;
            if (guardVelocity in visitedByVelocity && guardPosition in visitedByVelocity[guardVelocity])
                return true;
            visitedByVelocity[guardVelocity][guardPosition] = true;
        }
        return false;
    }

    bool[Vec2] uniqueLoopObstacles;
    bool[Vec2] visited;
    visited[guardPosition] = true;
    while (guardInMap)
    {
        while ((guardPosition + guardVelocity) in obstaclePositions)
            guardVelocity = guardVelocity.rotated90Clockwise;
        if ((guardPosition + guardVelocity) !in visited && checkLoop)
            uniqueLoopObstacles[guardPosition + guardVelocity] = true;
        guardPosition += guardVelocity;
        visited[guardPosition] = true;
    }

    uniqueLoopObstacles.byKey.walkLength.writeln;
}
