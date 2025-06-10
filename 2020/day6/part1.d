import std;

void main()
{
  File("input.txt").byLineCopy.array.split("")
    .map!(a => a.join.array.sort.uniq.walkLength)
    .sum
    .writeln;
}
