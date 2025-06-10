import std;

void main()
{
  int[] chargers = File("input.txt").byLine.map!(to!int).array;

  chargers = 0 ~ chargers ~ (chargers.maxElement + 3);

  int count1, count3;
  foreach (pair; chargers.sort.slide(2))
  {
    if (pair[1] - pair[0] == 1)
      count1++;
    if (pair[1] - pair[0] == 3)
      count3++;
  }

  writeln(count1 * count3);
}
