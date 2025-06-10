import std;

enum Operation : byte
{
  acc,
  jmp,
  nop
}

struct Instruction
{
  Operation op;
  int arg;

  this(T)(in T code)
  {
    static assert(isSomeString!T);
    auto s = code.split;
    op = s[0].to!Operation;
    arg = s[1].to!int;
  }
}

struct Processor
{
  int accumulator, ip;
  Instruction[] code;

  this(Instruction[] code)
  {
    this.code = code;
  }

  void next()
  {
    const Instruction i = code[ip];
    final switch (i.op)
    {
    case Operation.acc:
      accumulator += i.arg;
      ip++;
      break;
    case Operation.jmp:
      ip += i.arg;
      break;
    case Operation.nop:
      ip++;
      break;
    }
  }

  void run()
  {
    int[] beenThere;
    while (true)
    {
      if (beenThere.canFind(ip))
      {
        writeln(accumulator);
        return;
      }
      beenThere ~= ip;
      next();
    }
  }
}

void main()
{
  Instruction[] code = File("input.txt").byLine.map!(a => Instruction(a)).array;
  Processor processor = Processor(code);
  processor.run();
}
