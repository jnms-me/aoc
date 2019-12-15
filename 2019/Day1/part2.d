import std;

void main()
{
  auto f = File("input.txt", "r");
  auto input = f.byLine.map!(a => a.to!int);

  int total;
  foreach (mass; input)
  {
    int fuel = mass / 3 - 2;
    int lastFuel = fuel;
    while (lastFuel > 0)
    {
      lastFuel = lastFuel / 3 - 2;
      if (lastFuel > 0)
        fuel += lastFuel;
    }
    total += fuel;
  }
  total.writeln;
}
