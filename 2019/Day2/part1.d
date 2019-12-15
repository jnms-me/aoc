import std;

void interpretIntCode(ref int[] input)
{
  size_t i = 0;

  while (true)
  {
    int opCode = input[i];

    if (opCode == 1)
      input[input[i + 3]] = input[input[i + 1]] + input[input[i + 2]];
    else if (opCode == 2)
      input[input[i + 3]] = input[input[i + 1]] * input[input[i + 2]];
    else if (opCode == 99)
      break;
    else
    {
      stderr.writeln("Unknown opCode ", opCode, " at index ", i);
      break;
    }

    i += 4;
  }
}

void main()
{
  auto f = File("input.txt", "r");
  int[] input = f.readln.split(',').to!(int[]);

  // Magic 1202 program alarm
  input[1] = 12;
  input[2] = 2;
  interpretIntCode(input);

  input[0].writeln;
}
