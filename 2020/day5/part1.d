import std;

int binarySearch(const bool[] arr, const int size)
{
  int step = size / 2;
  int lower = 0;
  int upper = size - 1;

  foreach (a; arr)
  {
    if (a)
      lower += step;
    else
      upper -= step;
    step = step >> 1;
  }
  return lower;
}

void main()
{
  int id = 0;
  foreach (line; File("input.txt").byLine)
  {
    bool[] seat = line.map!((c) {
      final switch (c)
      {
      case 'B', 'R':
        return true;
      case 'F', 'L':
        return false;
      }
    }).array;
    int row = seat[0 .. 7].binarySearch(128);
    int col = seat[7 .. $].binarySearch(8);
    id = max(id, row * 8 + col);
  }
  writeln(id);
}
