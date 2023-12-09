/+dub.sdl:
+/
import std;

struct Race
{
    long time;
    long recordDistance;
}

void main()
{
    // Parse input
    Race[] races;
    {
        string times, recordDistances;
        readln.strip.formattedRead!"Time: %s"(times);
        readln.strip.formattedRead!"Distance: %s"(recordDistances);
        auto parseInts(string s) => s.split.map!(to!long); 
        foreach(t, r; zip(parseInts(times), parseInts(recordDistances)))
            races ~= Race(t, r);
    }

    // Calculate number of integer timings that beat the record
    long[] waysToBeatEachRace;
    foreach(race; races)
    {
        long[] chargeTimeToDistanceMap = uninitializedArray!(long[])(race.time + 1);
        foreach(chargeTime, ref distance; chargeTimeToDistanceMap)
        {
            long speed = chargeTime;
            distance = ((checked(race.time) - chargeTime) * speed).get;
        }
        waysToBeatEachRace ~= chargeTimeToDistanceMap.count!(dist => dist > race.recordDistance);
    }

    writeln(waysToBeatEachRace.reduce!"a*b");
}