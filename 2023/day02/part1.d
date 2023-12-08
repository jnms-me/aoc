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

    bool possibleWith(BagContents total)
    {
        foreach(draw; draws)
            if (draw.r > total.r || draw.g > total.g || draw.b > total.b)
                return false;
        return true;
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
}

alias BagContents = Draw;

void main()
{
    enum total = BagContents(12, 13, 14);

    stdin
        .byLine
        .map!(to!string)
        .map!Game                            // Parse the lines as Game structs
        .filter!(g => g.possibleWith(total)) // Remove impossible games
        .map!(g => g.id)                     // Select the game ids
        .sum
        .writeln;
}
