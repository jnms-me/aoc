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

struct Vec2
{
  long x, y;
}

void main()
{
  auto f = File("input.txt", "r");
  long[] memory = f.readln.split(',').to!(long[]);

  // long[] memory = "".split(",").to!(long[]);

  bool[Vec2] hull;
  Vec2 pos;

  long direction; // 0-3: up, right, down, left

  Vec2[] paintedTiles;

  Tid robot = spawnLinked(&runInterpreterAsync, memory.idup, [cast(long) 0].idup);

  try
  {
    while (true)
    {
      if ((pos in hull) is null)
        hull[pos] = false;

      // Send current panel
      if (hull[pos])
        robot.send(1);
      else
        robot.send(0);

      long paint = receiveOnly!long;
      long turn = receiveOnly!long;

      // Paint current tile
      if (paint)
      {
        hull[pos] = true;
        paintedTiles ~= pos;
      }
      else
        hull[pos] = false;

      // Set direction
      if (turn)
        direction++;
      else
        direction--;

      // Turn
      if (direction % 2)
        if (direction == 1)
          pos.x++;
        else
          pos.x--;
      else if (direction == 0)
            pos.y++;
          else
            pos.y--;

      if ((pos in hull) is null)
        hull[pos] = false;
    }
  }
  catch (LinkTerminated exception)
  {
    writeln(paintedTiles.sort!"a.y == b.y ? a.x > b.x : a.y > b.y".uniq.array.length);
  }
}
