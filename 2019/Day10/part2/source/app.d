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
  assert(Vec2(-20, 10).simplify == Vec2(-2, 1));
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

Vec2 castRay(Vec2 from, Vec2 to, Vec2[] astroidMap)
{
  if (from == to)
    return from;

  Vec2 sub = to - from;
  Vec2 interval = sub.simplify;

  foreach (astroid; astroidMap)
  {
    if (astroid == from || astroid == to)
      continue;

    Vec2 pos = from + interval;
    while (pos != to)
    {
      if (pos == astroid)
        return pos;

      pos += interval;
    }
  }
  return to;
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

  auto baseLocation = baseLocations.sort!((a, b) => a.visibleAstroids > b.visibleAstroids).front;

  Vec2[] border;
  foreach (i; baseLocation.location.x .. 40)
    border ~= Vec2(i, 0);
  foreach (i; 1 .. 40)
    border ~= Vec2(39, i);
  foreach_reverse (i; 0 .. 39)
    border ~= Vec2(i, 39);
  foreach_reverse (i; 1 .. 39)
    border ~= Vec2(0, i);
  foreach (i; 1 .. baseLocation.location.x)
    border ~= Vec2(i, 0);

  int count;

  // Never reaches 0, misses a lot of points by only using the border
  while (astroidMap.length > 0)
  {
    foreach (borderPoint; border)
    {
      Vec2 hit = castRay(baseLocation.location, borderPoint, astroidMap);
      if (hit == borderPoint)
        continue;
      astroidMap = astroidMap.remove(astroidMap.countUntil(hit));
      count++;
      writeln(borderPoint);
    }
  }

  count.writeln;
}
