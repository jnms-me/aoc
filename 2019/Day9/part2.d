import std;

struct IntCodeInterpreter
{
  size_t i = 0;
  size_t relativeBase;
  long[] memory;
  long opCode;
  long modes;

  this(long[] memory)
  {
    this.memory = memory;
    this.memory.length = 2 ^^ 16;
  }

  private long getParameter(long index)
  {
    long offset = 10 ^^ index;
    long mode = modes / offset % 10;

    // Position mode
    if (mode == 0)
      return memory[memory[i + index + 1]];
    // Parameter mode
    else if (mode == 1)
      return memory[i + index + 1];
    else if (mode == 2)
      return memory[relativeBase + memory[i + index + 1]];
    else
      throw new Exception("Unknown mode " ~ mode.to!string ~ " at index " ~ i.to!string);
  }

  private void setParameter(long index, long value)
  {
    long offset = 10 ^^ index;
    long mode = modes / offset % 10;

    // Position mode
    if (mode == 0)
      memory[memory[i + index + 1]] = value;
    // Parameter mode
    else if (mode == 1)
      memory[i + index + 1] = value;
    else if (mode == 2)
      memory[relativeBase + memory[i + index + 1]] = value;
    else
      throw new Exception("Unknown mode " ~ mode.to!string ~ " at index " ~ i.to!string);
  }

  long[] run(T)(T input)
  {
    static assert(isInputRange!T);
    long[] output;

    outer: while (true)
    {
      opCode = memory[i] % 100;
      modes = memory[i] / 100;

      switch (opCode)
      {
        // Addition
      case 1:
        setParameter(2, getParameter(0) + getParameter(1));
        i += 4;
        break;
        // Multiplication
      case 2:
        setParameter(2, getParameter(0) * getParameter(1));
        i += 4;
        break;
        // Read input
      case 3:
        if (!input.empty)
        {
          // First use up the input arg
          setParameter(0, input.front);
          input.popFront();
        }
        else
        {
          try
            setParameter(0, receiveOnly!long);
          catch (TidMissingException)
            stderr.writeln("Warning: Tried to receive more input than available");
        }
        i += 2;
        break;
        // Write output
      case 4:
        long data = getParameter(0);
        output ~= data;
        try
          ownerTid.send(data);
        catch (TidMissingException)
        {
        }
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
      case 9:
        relativeBase += getParameter(0);
        i += 2;
        break;
      case 99:
        break outer;
      default:
        throw new Exception("Unknown opCode " ~ opCode.to!string ~ " at index " ~ i.to!string);
        break outer;
      }
    }

    return output;
  }
}

static void runInterpreterAsync(immutable long[] memory, immutable long[] input)
{
  auto interpreter = IntCodeInterpreter(memory.dup);
  interpreter.run(input.dup);
}

void main()
{
  auto f = File("input.txt", "r");
  long[] memory = f.readln.split(',').to!(long[]);

  // long[] memory = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99".split(",").to!(long[]);
  // long[] memory = "1102,34915192,34915192,7,4,7,99,0".split(",").to!(long[]);
  // long[] memory = "104,1125899906842624,99".split(",").to!(long[]);

  auto interpreter = IntCodeInterpreter(memory);
  interpreter.run([2]).writeln;
}
