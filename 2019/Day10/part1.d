import std;

struct Vec2
{
  int x, y;
}

auto simplify(Vec2 vec)
{
  foreach (i; 2 .. min(vec.x, vec.y)+1)
    if (vec.x % i == 0 && vec.y % i == 0)
    {
      vec.x /= i;
      vec.y /= i;
      return vec;
    }
  return vec;
}

void main()
{
  Vec2(4, 2).simplify.writeln;
}
