/+dub.sdl:
+/
import std;

struct SeedSpec
{
    long start;
    long length;

}

struct Mapping
{
private:
    struct RangeMapping
    {
        long first, last, offset;
        
        long opCmp(const RangeMapping other) const
        {
            return (last - first) - (other.last - other.first);
        }
    }

    RangeMapping[] rangeMappings;

public:
    void addRangeMapping(long sourceStart, long destStart, long length)
    in (sourceStart >= 0 && destStart >= 0 && length > 0)
    {
        RangeMapping r;
        r.first = sourceStart;
        r.last = sourceStart + length - 1;
        r.offset = destStart - sourceStart;
        rangeMappings ~= r;
    }

    /// Optimizes access to RangeMappings with a large domain
    void resort()
    {
        rangeMappings.sort;
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
    SeedSpec[] seedSpecs;
    Mapping[] mappings;

    string seedsString;
    readln.strip.formattedRead!"seeds: %s"(seedsString);
    seedSpecs = seedsString
        .split(" ").map!(to!long).array                   // Convert seedsString to long[]
        .chunks(2).map!(a => SeedSpec(a[0], a[1])).array; // Build a SeedSpec from each pair of 2 longs
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

    foreach (mapping; mappings)
        mapping.resort;

    long[] seedSpecMinimums;
    seedSpecMinimums.length = seedSpecs.length;
    foreach (i, ss; parallel(seedSpecs))
    {
        long seedSpecMinimum = long.max;
        foreach (long seed; ss.start .. ss.start + ss.length)
        {
            long temp = seed;
            foreach(Mapping mapping; mappings)
                temp = mapping.convert(temp);
            seedSpecMinimum = min(temp, seedSpecMinimum);
        }
        seedSpecMinimums[i] = seedSpecMinimum;
        writefln("SeedSpec %u/%u done", i + 1, seedSpecs.length);
    }
    writeln(seedSpecMinimums.minElement);
}
