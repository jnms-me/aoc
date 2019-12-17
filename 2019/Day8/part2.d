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
    setScan(pixels);
    this.index = index;
  }

  void setScan(int[] pixels)
  {
    assert(pixels.length == Size.total);
    foreach (y; 0 .. cast(int) Size.height)
      foreach (x; 0 .. cast(int) Size.width)
      {
        this.pixels[y][x] = pixels.front;
        pixels.popFront();
      }
  }

  @property int[] scan()
  {
    int[] result;
    foreach (line; pixels)
      foreach (pixel; line)
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

  Layer image = Layer(2.repeat.take(Size.total).array, 0);

  {
    int[] finalPixels = image.scan;
    foreach_reverse (layer; layers)
    {
      int[] currPixels = layer.scan;
      foreach (i, ref pixel; finalPixels)
        if (currPixels[i] != 2)
          pixel = currPixels[i];
    }
    image.setScan(finalPixels);
  }

  foreach (line; image.pixels)
  {
    foreach (pixel; line)
      if (pixel == 0)
        write(" ");
      else
        write("█");
    writeln;
  }
}