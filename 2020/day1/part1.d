import std;

void main()
{
  int[] input;
  foreach (line; File("input.txt").byLine)
    input ~= line.to!int;

  writeln(solve(input));
}

int solve(int[] input)
{
  int solution;
  foreach (a; parallel(input))
    foreach(b; input)
      if (a + b == 2020)
        solution = a * b;
  return solution;
}
