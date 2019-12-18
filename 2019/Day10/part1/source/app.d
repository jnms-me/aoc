import std;
import gfm.math.vector;

alias Vec2 = Vector!(long, 2);

Vec2 simplify(Vec2 a)
{
	if (a.x == 0)
	{
		a.y /= abs(a.y);
	}
	else if (a.y == 0)
	{
		a.x /= abs(a.x);
	}
	else
	{
		foreach_reverse (i; 2 .. abs(min(a.x, a.y)) + 1)
			if (a % i == 0)
			{
				a /= i;
				break;
			}
	}
	return a;
}

unittest
{
	assert(Vec2(-20, 10).simplify == Vec2(-2,1));
}

bool canSee(Vec2 a, Vec2 b, Vec2[] astroidMap)
{
	if (a == b)
		return false;

	Vec2 sub = b - a;
	Vec2 interval = sub.simplify;

	bool visible = true;

	outer: foreach (astroid; astroidMap)
	{
		if (astroid == a || astroid == b)
			continue;

		Vec2 pos = a + interval;
		while (pos != b)
		{
			if (pos == astroid)
			{
				visible = false;
				break outer;
			}
			pos += interval;
		}
	}

	return visible;
}

struct BaseLocation
{
	Vec2 location;
	int visibleAstroids;
}

void main()
{
	size_t width;
	size_t height;
	string input;
	string[] inputArr;

	{
		auto f = File("../input.txt", "r");
		inputArr = f.byLine.map!(a => a.strip.to!string).array;

		width = inputArr[0].length;
		height = inputArr.length;
		input = inputArr.join;
	}

	Vec2[] astroidMap;
	BaseLocation[] baseLocations;

	foreach (y; 0 .. height)
		foreach (x; 0 .. width)
		{
			if (input[x + y * height] == '#')
				astroidMap ~= Vec2(x, y);
		}

	foreach (baseAstroid; astroidMap)
	{
		int canSeeCount;
		foreach (astroid; astroidMap)
		{
			if (baseAstroid == astroid)
				continue;
			if (baseAstroid.canSee(astroid, astroidMap))
				canSeeCount++;
		}
		baseLocations ~= BaseLocation(baseAstroid, canSeeCount);
	}

	baseLocations.sort!((a, b) => a.visibleAstroids > b.visibleAstroids).front.writeln;

	// bool[20][20] grid;

	// foreach (astroid; astroidMap)
	// 	grid[astroid.y][astroid.x] = Vec2(1, 8).canSee(astroid, astroidMap);

	// foreach (line; grid)
	// {
	// 	foreach (pixel; line)
	// 		if (pixel)
	// 			write("#");
	// 		else
	// 			write(".");
	// 	writeln;
	// }
}
