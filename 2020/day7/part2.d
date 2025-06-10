import std;

struct Bag
{
  string color;
  Tuple!(int, Bag)[] contents;

  this(string color, in string[][string] rules)
  {
    this.color = color;
    if (rules[color] == ["no other"])
      return;
    foreach (string bag; rules[color])
    {
      int amount;
      string childColor;
      bag.formattedRead!"%s %s"(amount, childColor);
      contents ~= tuple(amount, Bag(childColor, rules));
    }
  }

  long countChildren()
  {
    int count = 1;
    if (!contents.empty)
      foreach (Tuple!(int, Bag) bag; contents)
        count += bag[0] * bag[1].countChildren();
    return count;
  }
}

void main()
{
  string[][string] rules;

  File("input.txt").byLine
    .map!(a => a.replace(" bags", "").replace(" bag", "").replace(".", ""))
    .map!(a => a.array.split(" contain ").map!(to!string))
    .each!(rule => rules[rule[0]] = rule[1].split(", "));

  Bag bag = Bag("shiny gold", rules);
  writeln(bag.countChildren() - 1);
}
