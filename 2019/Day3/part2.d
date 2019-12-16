import std;

struct Vec2
{
  int x = 0;
  int y = 0;

  int sum()
  {
    return abs(x) + abs(y);
  }
}

Vec2[Vec2] getGrid(string[] wire1, string[] wire2)
{
  // x is steps1, y is steps2
  // [x] is x coord, [y] is coord
  Vec2[Vec2] grid;
  Vec2 lastPos;
  int steps = 0;

  foreach (instruction; wire1)
  {
    char direction = instruction[0];
    int distance = instruction[1 .. $].to!int;

    Vec2 pos = lastPos;

    if (direction == 'U')
      pos.y += distance;
    else if (direction == 'D')
      pos.y -= distance;
    else if (direction == 'R')
      pos.x += distance;
    else if (direction == 'L')
      pos.x -= distance;

    foreach (x; min(lastPos.x, pos.x) .. max(lastPos.x, pos.x) + 1)
      foreach (y; min(lastPos.y, pos.y) .. max(lastPos.y, pos.y) + 1)
      {
        Vec2 coord = Vec2(x, y);
        if ((coord in grid) is null)
          grid[coord] = Vec2(-1, -1);
        else if (coord == lastPos)
          continue;
        grid[coord].x = steps;
        steps++;
      }
    lastPos = pos;
  }

  lastPos = Vec2(0, 0);
  steps = 1;

  foreach (instruction; wire2)
  {
    char direction = instruction[0];
    int distance = instruction[1 .. $].to!int;

    Vec2 pos = lastPos;

    if (direction == 'U')
      pos.y += distance;
    else if (direction == 'D')
      pos.y -= distance;
    else if (direction == 'R')
      pos.x += distance;
    else if (direction == 'L')
      pos.x -= distance;

    foreach (x; min(lastPos.x, pos.x) .. max(lastPos.x, pos.x) + 1)
      foreach (y; min(lastPos.y, pos.y) .. max(lastPos.y, pos.y) + 1)
      {
        Vec2 coord = Vec2(x, y);
        if ((coord in grid) is null)
          grid[coord] = Vec2(-1, -1);
        else if (coord == lastPos)
          continue;
        grid[coord].y = steps;
        steps++;
      }
    lastPos = pos;
  }

  return grid;
}

void main()
{
  /*
  auto f = File("input.txt", "r");
  auto wire1 = f.readln.strip.split(",");
  auto wire2 = f.readln.strip.split(",");
  f.close();
  */

  /*
  auto wire1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72".split(',');
  auto wire2 = "U62,R66,U55,R34,D71,R55,D58,R83".split(',');
  */

  /*
  auto wire1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51".split(',');
  auto wire2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7".split(',');
  */

  // /*
  auto wire1 = "R8,U5,L5,D3".split(',');
  auto wire2 = "U7,R6,D4,L4".split(',');
  // */

  auto result = getGrid(wire1, wire2).byValue
    .filter!(a => a.x > 0 && a.y > 0)
    .map!(a => a.sum())
    .array
    .sort;
  writeln(result);
}
