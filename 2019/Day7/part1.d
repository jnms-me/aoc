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

  int[] run(int[] input)
  {
    int[] output;

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
        setParameter(0, input.front);
        input.popFront();
        i += 2;
        break;
        // Write output
      case 4:
        output ~= getParameter(0);
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

    return output;
  }
}

void main()
{
  auto f = File("input.txt", "r");
  int[] memory = f.readln.split(',').to!(int[]);

  /*
  int[] memory = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0".split(",")
    .to!(int[]);
  */

  int optimal;
  int[] answer;

  foreach (a; 0 .. 5)
    foreach (b; 0 .. 5)
      foreach (c; 0 .. 5)
        foreach (d; 0 .. 5)
          foreach (e; 0 .. 5)
          {
            if ([a, b, c, d, e].sort.array != [0, 1, 2, 3, 4])
              continue;

            int amp1Output = IntCodeInterpreter(memory).run([a, 0])[0];
            int amp2Output = IntCodeInterpreter(memory).run([b, amp1Output])[0];
            int amp3Output = IntCodeInterpreter(memory).run([c, amp2Output])[0];
            int amp4Output = IntCodeInterpreter(memory).run([d, amp3Output])[0];
            int amp5Output = IntCodeInterpreter(memory).run([e, amp4Output])[0];

            if (amp5Output > optimal)
            {
              optimal = amp5Output;
              answer = [a, b, c, d, e];
            }
          }

  optimal.writeln;
  answer.writeln;
}
