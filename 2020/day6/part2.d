import std;

void main()
{
  File("input.txt").byLineCopy.array.split("")
    .map!(a => a.join.array.sort.group.filter!(b => b[1] == a.length).walkLength)
    .sum
    .writeln;
}
