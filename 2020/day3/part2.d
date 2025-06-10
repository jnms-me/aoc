import std;

void main()
{
  bool[][] array;
  int i;
  foreach (line; File("input.txt").byLine)
  {
    array.length++;
    foreach(c; line)
      array[i] ~= c == '#';
    i++;
  }

  struct Vec2 {int x, y;}

  Vec2[] steps = [
    Vec2(1, 1),
    Vec2(3, 1),
    Vec2(5, 1),
    Vec2(7, 1),
    Vec2(1, 2)
  ];

  long[] result;
  foreach (step; steps)
  {
    int x, y;
    int count;
    while(y < array.length)
    {
      if (array[y][x % array[0].length])
        count++;
      x += step.x;
      y += step.y;
    }
    result ~= count;
  }

  writeln(result.reduce!((a, b) => a*b));
}