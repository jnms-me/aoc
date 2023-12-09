/+dub.sdl:
+/
import std;

void main()
{
    // Parse input
    long raceTime           = readln.filter!isNumber.to!long;
    long raceRecordDistance = readln.filter!isNumber.to!long;

    // Calculate number of integer timings that beat the record
    long waysToBeatRaceRecord;
    {
        long[] chargeTimeToDistanceMap = uninitializedArray!(long[])(raceTime + 1);
        foreach(chargeTime, ref distance; parallel(chargeTimeToDistanceMap))
        {
            long speed = chargeTime;
            distance = ((checked(raceTime) - chargeTime) * speed).get;
        }
        waysToBeatRaceRecord = chargeTimeToDistanceMap.count!(dist => dist > raceRecordDistance);
    }

    writeln(waysToBeatRaceRecord);
}