/+dub.sdl:
+/
import std;
import std.format : f = format;

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
    string left;
    string right;
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
        Node node;
        readln.strip.formattedRead!"%s = (%s, %s)"(node.id, node.left, node.right);
        graph[node.id] = node;
    }

    // Walk graph using steps
    int stepsWalked = 0;
    {
        auto repeatingSteps = steps.repeat.joiner;
        Node curr = graph["AAA"];
        do
        {
            Step step = repeatingSteps.front;
            repeatingSteps.popFront;

            if (step == Step.Left)
                curr = graph[curr.left];
            else if (step == Step.Right)
                curr = graph[curr.right];
            else
                assert(false);
            
            stepsWalked++;
        }
        while (curr.id != "ZZZ");
    }

    writeln(stepsWalked);
}
