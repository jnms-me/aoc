import std;

static int lower = 387638;
static int upper = 919123;

void main()
{
  int passwords;
  foreach (i; lower..upper+1)
  {
    string s = i.to!string;
    if (s.group.assocArray.byValue.any!(a => a == 2))
      if (s.isSorted)
        passwords++;
  }
  passwords.writeln;
}