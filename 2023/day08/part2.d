/+dub.sdl:
+/
import std;
import std.format : f = format;

enum ClearLineCharSequence = "\33[2K\r";

enum Step : bool
{
    Left,
    Right
}

Step charToStep(dchar c)
{
    switch (c)
    {
    case 'L':
        return Step.Left;
    case 'R':
        return Step.Right;
    default:
        assert(false, f!"Invalid step character %c"(c));
    }
}

struct Node
{
    string id;
    Node* left;
    Node* right;

    Node* takeStep(in Step step)
    {
        if (step == Step.Left)
            return left;
        else if (step == Step.Right)
            return right;
        else
            assert(false, "Invalid step value");
    }
}

struct LoopInfo
{
    long start;
    long period;
    long[] endIndices; // Counted from start
}

void main()
{
    Step[] steps;
    Node[string] graph;

    // Parse input
    steps = readln.strip.map!charToStep.array;
    readln;
    while (!stdin.eof)
    {
        string id, left, right;
        readln.strip.formattedRead!"%s = (%s, %s)"(id, left, right);
        foreach (s; [id, left, right])
            assert(s.length == 3);

        // Create empty left/right nodes if needed
        foreach (s; [left, right])
            if (s !in graph)
                graph[s] = Node();

        graph[id] = Node(id, left in graph, right in graph);
    }

    // Collect starting nodes
    Node*[] startNodes = graph
        .values
        .filter!(node => node.id.endsWith('A'))
        .map!(node => node.id in graph)
        .array;
    startNodes.sort!"a.id<b.id";

    // Detect loops in each path taken
    LoopInfo[] loops;
    foreach (startNode; startNodes)
    {
        long stepsWalked = 0;
        auto repeatingSteps = steps.repeat.joiner;
        Node* curr = startNode;
        Node*[] history = [curr];

        bool inLoop()
        {
            for (long i = stepsWalked - steps.length; i >= 0; i -= steps.length)
                if (curr == history[i])
                    return true;
            return false;
        }

        while (!inLoop)
        {
            Step step = repeatingSteps.front;
            repeatingSteps.popFront;
            curr = curr.takeStep(step);
            stepsWalked++;
            history ~= curr;
        }

        LoopInfo loop;
        loop.start = history.countUntil(curr);
        loop.period = stepsWalked - loop.start;
        foreach (i, node; history[loop.start .. $ - 1])
            if (node.id.endsWith('Z'))
                loop.endIndices ~= cast(long) i;
        loops ~= loop;
    }

    // Increase some loop start offsets untill they align
    // Also shift the end incides
    long maxStartOffset = loops.map!(loop => loop.start).maxElement;
    foreach (ref loop; loops)
    {
        if (loop.start != maxStartOffset)
        {
            long diff = maxStartOffset - loop.start;
            loop.start = maxStartOffset;
            foreach (ref i; loop.endIndices)
                i = (i - diff) % loop.period;
        }
    }

    long stepsWalked = maxStartOffset + loops[0].endIndices[0];
    bool allAtEnd()
    {
        foreach (LoopInfo loop; loops)
            if (!loop.endIndices.any!(i => (loop.start + stepsWalked + i) % loop.period) == 0)
                return false;
        return true;
    }

    while (!allAtEnd)
        stepsWalked += loops[0].period;

    writeln(stepsWalked);
}
