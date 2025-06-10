import std;

class Tree {
  Tree[3] children;

  this(in int[] chargers) {
    const jolts = chargers[0];
    foreach (j; 1 .. 4)
    {
      if (j >= chargers.length)
        break;
      const int diff = chargers[j] - chargers[0];
      if (diff <= 3)
        children[j-1] = new Tree(chargers[j..$]);
      if (diff >= 3)
        break;
    }
  }

  long countLeaves()
  {
    if (children.matchAll!"a == null")
      return 1;
    return children.map!(a => a.countLeaves()).sum;
  }
}

void main()
{
  int[] chargers = File("input.txt").byLine.map!(to!int).array;

  chargers = 0 ~ chargers.sort.array ~ (chargers.maxElement + 3);

  Tree tree = Tree(chargers);
  writeln(tree.children.length);
  writeln(tree.countLeaves);
}
