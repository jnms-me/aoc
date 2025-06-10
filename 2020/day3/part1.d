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

  int x, y;
  int count;
  while(y < array.length)
  {
    if (array[y][x % array[0].length])
      count++;
    x += 3;
    y += 1;
  }

  writeln(count);
}