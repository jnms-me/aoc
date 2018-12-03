import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.algorithm;

void main()
{
    auto data = readText("file.txt").split('\n');
    int[] rects[];
    int[] xCoords[];
    int[] yCoords[];
    foreach (line; data) {
        rects ~= to!(int[])(line.split(' '));
    }

    foreach (rect; rects) {
        int[] x;
        int[] y;
        for (int i = 0; i < rect[3]; i++) {
            for (int j = 0; j < rect[4]; j++) {
                x ~= rect[1] + i;
                y ~= rect[2] + j;
            }
        }
        xCoords ~= x;
        yCoords ~= y;
    }

    int id = -1;
    int success = 0;

    outer: for (int i = 0; i < xCoords.length; i++) {
        for (int j = 0; j < xCoords.length; j++) {
            success = 1;
            for (int k = 0; k < xCoords.length; k++) {
                for (int l = 0; l < xCoords.length; l++) {
                    if (success == 1) {
                        if (xCoords[i] != xCoords[k] && yCoords[j] != yCoords[l]) {
                            success = 1;
                        } else {
                            success = 0;
                        }
                    }
                }
            }
            if (success == 1) {
                id = i;
                break outer;
            }
        }
        writeln(i);
    }

    writeln(id);
}
