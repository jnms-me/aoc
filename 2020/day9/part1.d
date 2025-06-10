import std;

enum l = 25;

void main()
{
  File("input.txt").byLine.map!(to!long).array.findInvalid.writeln;
}

long findInvalid(in long[] input)
{
  foreach (slice; input.slide(l + 1))
  {
    const long[] preamble = slice[0 .. $ - 1];
    const long target = slice[$ - 1];

    auto sums = cartesianProduct(preamble, preamble).map!(a => a[0] + a[1]);
    if (!sums.canFind(target))
      return target;
  }
  return -1;
}
