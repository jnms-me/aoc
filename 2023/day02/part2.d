/+dub.sdl:
+/
import std;

struct Game
{
    int id;
    Draw[] draws;

    this(string s)
    {
        string drawsString;
        s.formattedRead!"Game %d: %s"(id, drawsString);
        draws = drawsString.split(";").map!strip.map!Draw.array;
    }

    bool possibleWith(BagContents total) const
    {
        foreach(draw; draws)
            if (draw.r > total.r || draw.g > total.g || draw.b > total.b)
                return false;
        return true;
    }

    BagContents minRequiredBagContents() const
    {
        BagContents result;
        foreach(draw; draws)
        {
            result.r = max(result.r, draw.r);
            result.g = max(result.g, draw.g);
            result.b = max(result.b, draw.b);
        }
        return result;
    }
}

struct Draw
{
    int r, g, b;

    this(int r, int g, int b)
    {
        this.r = r;
        this.g = g;
        this.b = b;
    }

    this(string s)
    {
        foreach(segment; s.split(",").map!strip)
        {
            int amount; string color;
            segment.formattedRead!"%d %s"(amount, color);
            if (color == "red") r += amount;
            else if (color == "green") g += amount;
            else if (color == "blue") b += amount;
        }
    }

    int power() const
    {
        return r * g * b;
    }
}

alias BagContents = Draw;

void main()
{
    stdin
        .byLine
        .map!(to!string)
        .map!Game                            // Parse the lines as Game structs
        .map!(g => g.minRequiredBagContents) // Calculate min required bag contents for each game
        .map!(b => b.power)                  // Calculate the "power" of each bag's contents
        .sum
        .writeln;
}
