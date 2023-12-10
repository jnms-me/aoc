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

    // Walk graph using steps
    long stepsWalked = 0;
    {
        auto repeatingSteps = steps.repeat.joiner;

        Node*[6] currNodes;
        currNodes[] = graph
            .values
            .filter!(node => node.id[$ - 1] == 'A')
            .map!(node => node.id in graph)
            .array;
        currNodes[].sort!"a.id<b.id";

        writefln!"%d simultanious walks"(currNodes.length);
        do
        {
            Step step = repeatingSteps.front;
            repeatingSteps.popFront;

            foreach (ref node; currNodes)
                node = node.takeStep(step);

            stepsWalked++;

            if (stepsWalked % 1_000_000_000 == 0)
            {
                write(ClearLineCharSequence);
                writef!"%d billion steps walked"(stepsWalked / 1_000_000_000);
                stdout.flush;
            }
        }
        while (!currNodes[].all!(node => node.id[$ - 1] == 'Z'));
    }

    writeln(stepsWalked);
}
