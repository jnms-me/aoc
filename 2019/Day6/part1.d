import std;

struct Body
{
  Body*[] children;

  int countChildren()
  {
    int count = 0;
    count += children.length;
    foreach (child; children)
      count += (*child).countChildren();
    return count;
  }
}

void main()
{
  auto f = File("input.txt", "r");
  auto input = f.byLine.map!(a => a.split(')').to!(string[])).array;

  string com;

  Body[string] bodies;

  foreach (orbit; input)
  {
    string body1 = cast(string) orbit[0];
    string body2 = cast(string) orbit[1];

    // Find Center Of Mass
    if (com.empty && input.filter!(a => orbit[0] == a[1]).empty)
      com = orbit[0];

    if ((body1 in bodies) is null)
      bodies[body1] = Body();
    if ((body2 in bodies) is null)
      bodies[body2] = Body();

    bodies[body1].children ~= (body2 in bodies);
  }

  writeln("COM: ", com);
  bodies.byValue.map!(a => a.countChildren()).sum.writeln;
}
