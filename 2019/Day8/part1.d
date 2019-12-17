import std;

enum Size
{
  width = 25,
  height = 6,
  total = width * height
}

struct Layer
{
  int[Size.width][Size.height] pixels;
  int index;

  this(int[] pixels, int index)
  {
    assert(pixels.length == Size.total);
    foreach (y; 0 .. cast(int) Size.height)
      foreach (x; 0 .. cast(int) Size.width)
      {
        this.pixels[y][x] = pixels.front;
        pixels.popFront();
      }
    this.index = index;
  }

  @property int[] scan()
  {
    int[] result;
    foreach(line; pixels)
      foreach(pixel; line)
        result ~= pixel;
    return result;
  }
}

void main()
{
  auto f = File("input.txt", "r");
  int[] input = f.readln.strip.map!(c => c.to!string
      .to!int).array;

  Layer[] layers;

  // Parse layers
  {
    int[] layerInput = input.dup;
    int layerIndex;
    foreach (layer; 0 .. input.length / Size.total)
    {
      layers ~= Layer(layerInput.take(Size.total), layerIndex);
      layerInput = layerInput.drop(Size.total);
      layerIndex++;
    }
  }

  Layer fewestZero = layers.sort!((a, b) => a.scan.count(0) < b.scan.count(0)).front;

  writeln("Layer index: ", fewestZero.index);
  writeln("0s: ", fewestZero.scan.count(0));
  writeln("1s * 2s: ", fewestZero.scan.count(1) * fewestZero.scan.count(2));
}