import std;

void main()
{
  auto f = File("input.txt", "r");
  auto input = f.byLine.map!(a => a.to!int);

  input.map!(a => a / 3 - 2).sum.writeln;
}
