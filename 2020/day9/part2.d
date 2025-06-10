import std;

enum l = 25;

void main()
{
  long[] input = File("input.txt").byLine.map!(to!long).array;
  writeln(findWeakness(input, findInvalid(input)));
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

long findWeakness(ref long[] input, long target)
{
  while (!input.empty)
  {
    foreach (i; 0 .. input.length)
    {
      const long[] slice = input[0..i];
      if (slice.sum == target)
        return slice.minElement + slice.maxElement;
    }
    input = input.drop(1);
  }
  return -1;
}
