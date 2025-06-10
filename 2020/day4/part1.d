import std;

string[string][] getInput()
{
  string[] array;
  string buffer;
  foreach (line; File("input.txt").byLine)
  {
    buffer ~= line ~ " ";
    if (line == "")
    {
      array ~= buffer;
      buffer = "";
    }
  }
  array ~= buffer; // Last line isn't ""

  string[string][] result = new string[string][](array.length);

  foreach (i, passport; array)
    foreach (entry; passport.split)
    {
      auto pair = entry.split(":");
      result[i][pair[0]] = pair[1];
    }
  return result;
}

bool isValid(string[string] passport)
{
  string[] required = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
  foreach (string key; required)
    if ((key in passport) is null)
      return false;
  return true;
}

void main()
{
  string[string][] passports = getInput();

  auto count = passports.filter!(isValid).count;
  writeln(count);
}