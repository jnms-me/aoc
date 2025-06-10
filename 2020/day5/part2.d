#!/usr/bin/env -S rdmd -O -inline -release
import std;

@safe pure long binarySearch(in bool[] arr)
{
  ulong step = 2 ^^ arr.length / 2;
  ulong lower = 0;
  ulong upper = 2 ^^ arr.length - 1;

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

@safe pure long idOf(in bool[] seat)
{
  return binarySearch(seat[0 .. 7]) * 8 + binarySearch(seat[7 .. $]);
}

void main()
{
  long[] ids;
  foreach (line; File("input.txt").byLine)
    ids ~= line.map!((c) {
      final switch (c)
      {
      case 'B', 'R':
        return true;
      case 'F', 'L':
        return false;
      }
    }).array.idOf;
  writeln(ids.sort.findAdjacent!"a + 2 == b".front + 1);
}
