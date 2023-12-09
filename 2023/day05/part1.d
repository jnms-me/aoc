/+dub.sdl:
+/
import std;

struct Mapping
{
    struct RangeMapping { long first, last, offset; }
    RangeMapping[] rangeMappings;

    void addRangeMapping(long sourceStart, long destStart, long length)
    in (sourceStart >= 0 && destStart >= 0 && length > 0)
    {
        RangeMapping r;
        r.first = sourceStart;
        r.last = sourceStart + length - 1;
        r.offset = destStart - sourceStart;
        rangeMappings ~= r;
    }

    long convert(long input) const
    {
        foreach(r; rangeMappings)
            if (r.first <= input && input <= r.last)
                return input + r.offset;
        return input;
    }
}

void main()
{
    long[] seeds;
    Mapping[] mappings;

    readln.strip.formattedRead!"seeds: %(%d %)"(seeds);
    readln.strip.formattedRead!"";
    while (!stdin.eof)
    {
        enforce(readln.strip.endsWith(" map:"));
        Mapping mapping;
        while (!stdin.eof)
        {
            string line = readln.strip;
            if (!line.length)
                break;
            long destStart, sourceStart, length;
            line.formattedRead!"%d %d %d"(destStart, sourceStart, length);
            mapping.addRangeMapping(sourceStart, destStart, length);
        }
        mappings ~= mapping;
    }

    long[] results;
    results.length = seeds.length;

    foreach (size_t i, long seed; seeds)
    {
        long temp = seed;
        foreach(Mapping mapping; mappings)
            temp = mapping.convert(temp);
        results[i] = temp;
    }
    
    writeln(results.minElement);
}
