import std;

void main()
{
  string[][string] hashmap;

  File("input.txt").byLine
    .map!(a => a.replace(" bags", "").replace(" bag", "").replace(".", ""))
    .map!(a => a.array.split(" contain ").map!(to!string))
    .each!(rule => hashmap[rule[0]] = rule[1].split(", "));

  SList!string s;
  foreach (key, value; hashmap)
    if (!value.filter!(a => a.canFind("shiny gold")).empty)
      s.insertFront(key);

  string[] arr;
  while(!s.empty)
  {
    string curr = s.front;
    arr ~= curr;
    s.removeFront();
    foreach (key, value; hashmap)
      if (!value.filter!(a => a.canFind(curr)).empty)
        s.insertFront(key);
  }

  writeln(arr.sort.uniq.walkLength);
}
