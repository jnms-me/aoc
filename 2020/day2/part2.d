import std;

void main()
{
  int count;
  foreach (line; File("input.txt").byLine)
    if (valid(line.to!string))
      count++;
  writeln(count);
}

bool valid(string s)
{
  auto split1 = s.split(":");
  auto split2 = split1[0].split(" ");
  auto split3 = split2[0].split("-");

  immutable string password = split1[1].strip();
  immutable char character = split2[1][0];
  immutable int lowerBound = split3[0].to!int;
  immutable int upperBound = split3[1].to!int;

  return (password[lowerBound-1] == character) ^ (password[upperBound-1] == character);
}