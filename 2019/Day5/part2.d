import std;

struct IntCodeInterpreter
{
  size_t i = 0;
  int[] memory;
  int opCode;
  int modes;

  this(int[] memory)
  {
    this.memory = memory;
  }

  private int getParameter(int index)
  {
    int offset = 10 ^^ index;
    int mode = modes / offset % 10 == 1;

    // Position mode
    if (mode == 0)
      return memory[memory[i + index + 1]];
    // Parameter mode
    else if (mode == 1)
      return memory[i + index + 1];
    else
      throw new Exception("Unknown mode " ~ mode.to!string ~ " at index " ~ i.to!string);
  }

  private void setParameter(int index, int value)
  {
    int offset = 10 ^^ index;
    int mode = modes / offset % 10 == 1;

    // Position mode
    if (mode == 0)
      memory[memory[i + index + 1]] = value;
    // Parameter mode
    else if (mode == 1)
      memory[i + index + 1] = value;
    else
      throw new Exception("Unknown mode " ~ mode.to!string ~ " at index " ~ i.to!string);
  }

  void run()
  {
    outer: while (true)
    {
      opCode = memory[i] % 100;
      modes = memory[i] / 100;

      switch (opCode)
      {
      // Adddition
      case 1:
        setParameter(2, getParameter(0) + getParameter(1));
        i += 4;
        break;
      // Multiplication
      case 2:
        setParameter(2, getParameter(0) * getParameter(1));
        i += 4;
        break;
      // Read stdin
      case 3:
        setParameter(0, readln.strip.to!int);
        i += 2;
        break;
      // Write stdout
      case 4:
        getParameter(0).writeln;
        i += 2;
        break;
      // Jump if true
      case 5:
        if (getParameter(0) != 0)
          i = getParameter(1);
        else
          i += 3;
        break;
      // Jump if false
      case 6:
        if (getParameter(0) == 0)
          i = getParameter(1);
        else
          i += 3;
        break;
      // Less than
      case 7:
        if (getParameter(0) < getParameter(1))
          setParameter(2, 1);
        else
          setParameter(2, 0);
        i += 4;
        break;
      // Equals
      case 8:
        if (getParameter(0) == getParameter(1))
          setParameter(2, 1);
        else
          setParameter(2, 0);
        i += 4;
        break;
      case 99:
        break outer;
      default:
        throw new Exception("Unknown opCode " ~ opCode.to!string ~ " at index ", i.to!string);
        break outer;
      }
    }
  }
}

void main()
{
  auto f = File("input.txt", "r");
  int[] input = f.readln.split(',').to!(int[]);

  auto interpreter = IntCodeInterpreter(input);
  interpreter.run();
}
