/+dub.sdl:
+/
import std;
import std.uni : isAlpha;

struct Point
{
    int x, y;

    bool adjacentTo(in Point other) const
    {
        return abs(x - other.x) <= 1
            && abs(y - other.y) <= 1;
    }
}

void main()
{
    dstring[] lines = stdin.byLine.map!(to!dstring).array;

    // Find all digit and symbol locations
    Point[] digitLocations;
    Point[] symbolLocations;
    foreach (y, dstring line; lines)
        foreach (x, dchar c; line)
        {
            if (c.isNumber)
                digitLocations ~= Point(x.to!int, y.to!int);
            else if (c != '.' && !c.isAlpha)
                symbolLocations ~= Point(x.to!int, y.to!int);
        }
    
    // Join adjecent digits into numbers
    Point[][] numberLocations;
    {
        Point[] currentNumber;

        void endNumber()
        {
            numberLocations ~= currentNumber;
            currentNumber = [];
        }

        if (digitLocations.length > 0)
        {
            foreach(i, Point digit; digitLocations)
            {
                if (i != 0)
                {
                    Point previousDigit = currentNumber.back;
                    bool digitsFollow = previousDigit.y == digit.y && previousDigit.x + 1 == digit.x;
                    if (!digitsFollow)
                        endNumber;
                }
                currentNumber ~= digit;
            }
            endNumber;
        }
    }

    // Filter out numbers not next to symbols
    Point[][] partNumberLocations;
    {
        bool isNumberNextToSymbol(Point[] digitLocations)
        {
            foreach (Point digit; digitLocations)
                foreach(Point symbol; symbolLocations)
                    if (digit.adjacentTo(symbol))
                        return true;
            return false;
        }

        partNumberLocations = numberLocations.filter!isNumberNextToSymbol.array;
    }

    // Convert part number digit locations into integers
    int[] partNumbers;
    {
        int digitLocationsToInt(Point[] digitLocations)
        {
            char[] s;
            s.reserve(digitLocations.length);

            foreach(digit; digitLocations)
                s ~= lines[digit.y][digit.x];
            
            return s.to!int;
        }

        partNumbers = partNumberLocations.map!digitLocationsToInt.array;
    }

    long[] gearRatios;
    foreach (Point symbol; symbolLocations)
        if (lines[symbol.y][symbol.x] == '*')
        {
            size_t[] adjacentPartNumbersIndices = [];
            foreach(i, partNumber; partNumberLocations)
                if (partNumber.any!(digit => symbol.adjacentTo(digit)))
                        adjacentPartNumbersIndices ~= i;
            if (adjacentPartNumbersIndices.length == 2)
            {
                long ratio = 1;
                foreach(i; adjacentPartNumbersIndices)
                    ratio *= partNumbers[i];
                gearRatios ~= ratio;
            }
        }
    
    writeln(gearRatios.sum);
}
