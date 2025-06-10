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

  immutable int byr = passport["byr"].to!int;
  immutable int iyr = passport["iyr"].to!int;
  immutable int eyr = passport["eyr"].to!int;
  immutable string hgt = passport["hgt"];
  immutable string hcl = passport["hcl"];
  immutable string ecl = passport["ecl"];
  immutable string pid = passport["pid"];

  return 
    (byr >= 1920 && byr <= 2002)
    && (iyr >= 2010 && iyr <= 2020)
    && (eyr >= 2020 && eyr <= 2030)
    && (hgt.length > 2)
    && (
      (hgt[$-2..$] == "cm" && hgt[0..$-2].to!int >= 150 && hgt[0..$-2].to!int <= 193)
      || (hgt[$-2..$] == "in" && hgt[0..$-2].to!int >= 59 && hgt[0..$-2].to!int <= 76)
    )
    && (hcl.length == 7 && hcl[0] == '#')
    && (hcl[1..$].all!isHexDigit)
    && (["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].any!(a => a == ecl))
    && (pid.length == 9 && pid.all!isDigit)
    ;
}

void main()
{
  string[string][] passports = getInput();

  auto count = passports.filter!(isValid).count;
  writeln(count);
}