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
      foreach(c; input)
        if (a + b + c == 2020)
          solution = a * b * c;
  return solution;
}