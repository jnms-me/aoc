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

Vec2[] getIntersections(string[] wire1, string[] wire2)
{
  // 0 is empty
  // 1 is wire1
  // 2 is wire2
  // 3 is both
  int[Vec2] grid;
  Vec2 lastPos;

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
          grid[coord] = 0;
        grid[coord] += 1;
      }
    lastPos = pos;
  }

  lastPos = Vec2(0, 0);

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
          grid[coord] = 0;
        grid[coord] += 2;
      }
    lastPos = pos;
  }

  Vec2[] intersections;
  foreach (key, value; grid)
  {
    if (value == 3)
      intersections ~= key;
  }
  return intersections;
}

void main()
{
  auto f = File("input.txt", "r");
  auto wire1 = f.readln.strip.split(",");
  auto wire2 = f.readln.strip.split(",");
  f.close();

  /*
  auto wire1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72".split(',');
  auto wire2 = "U62,R66,U55,R34,D71,R55,D58,R83".split(',');
  */

  /*
  auto wire1 = "R8,U5,L5,D3".split(',');
  auto wire2 = "U7,R6,D4,L4".split(',');
  */

  //writeln(wire1);
  //writeln(wire2);

  getIntersections(wire1, wire2).sort!"a.sum() < b.sum()".map!(a => a.sum()).writeln;
}
