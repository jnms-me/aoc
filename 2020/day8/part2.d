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
  int[] beenThere;

  this(Instruction[] code)
  {
    this.code = code;
  }

  this(ref return scope Processor src)
  {
    accumulator = src.accumulator;
    ip = src.ip;
    code = src.code.dup;
    beenThere = src.beenThere.dup;
  }

  void next()
  {
    beenThere ~= ip;
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

  bool run()
  {
    while (true)
    {
      if (ip == code.length)
        return true;
      if (beenThere.canFind(ip))
        return false;
      next();
    }
  }

  void nextFixable()
  {
    do
      next();
    while (code[ip].op != Operation.jmp && code[ip].op != Operation.nop);
  }

  void fix()
  {
    if (code[ip].op == Operation.jmp)
      code[ip].op = Operation.nop;
    else
      code[ip].op = Operation.jmp;
  }
}

void main()
{
  Instruction[] code = File("input.txt").byLine.map!(a => Instruction(a)).array;
  Processor processor = Processor(code);
  while (true)
  {
    Processor dup = processor;
    dup.nextFixable();
    dup.fix();
    if (dup.run())
    {
      writeln(dup.accumulator);
      break;
    }
    processor.nextFixable();
  }
}
