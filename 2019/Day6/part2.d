import std;

struct Body
{
  Body* parent;
  Body*[] children;
  string name;

  this(string name)
  {
    this.name = name;
  }

  int countChildren()
  {
    int count = 0;
    count += children.length;
    foreach (child; children)
      count += (*child).countChildren();
    return count;
  }

  string str(ref Body[string] bodies)
  {
    return "\"" ~ name ~ "\"" ~ ":{" ~ children.map!(a => a.str(bodies)).join(",") ~ "}";
  }
}

void main()
{
  auto f = File("input.txt", "r");
  auto input = f.byLine.map!(a => a.split(')').to!(string[])).array;

  Body[string] bodies;

  foreach (orbit; input)
  {
    string body1 = cast(string) orbit[0];
    string body2 = cast(string) orbit[1];

    if ((body1 in bodies) is null)
      bodies[body1] = Body(body1);
    if ((body2 in bodies) is null)
      bodies[body2] = Body(body2);

    bodies[body1].children ~= (body2 in bodies);
    bodies[body2].parent = (body1 in bodies);
  }

  bodies.byValue.map!(a => a.countChildren()).sum.writeln;

  writeln("{", bodies["COM"].str(bodies), "}");
}
