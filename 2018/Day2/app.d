import std.stdio;
import std.file;
import std.string;

void main()
{
	auto data = readText("file.txt").split("\n");
    auto total2s = 0;
    auto total3s = 0;

    string boxes[];

    foreach (id; data) {
        char finished[];
        bool canCount2 = true;
        bool canCount3 = true;
        foreach (currentChar; id) {
            auto charFinished = false;
            foreach (c; finished) {
                if (c == currentChar) {
                    charFinished = true;
                    break;
                }
            }
            if (!charFinished) {
                finished ~= currentChar;
                auto count = 0;
                foreach (c; id) {
                    if (c == currentChar) {
                        count++;
                    }
                }
                if (count == 2 && canCount2) {
                    total2s++;
                    canCount2 = false;
                }
                else if (count == 3 && canCount3) {
                    total3s++;
                    canCount3 = false;
                }
            }
        }
        if (!canCount2 || !canCount3) {
            boxes ~= id;
        }
    }

    writeln("Total 2's\t: ", total2s);
    writeln("Total 3's\t: ", total3s);
    writeln("Checksum\t: ", total2s * total3s);

    outer: foreach(currentBox; boxes) {
        foreach(box; boxes) {
            auto count = 0;
            for (auto i = 0; i < currentBox.length; i++) {
                if (currentBox[i] != box[i]) {
                    count++;
                }
            }
            if (count == 1) {
                writeln("Box 1:\t", currentBox);
                writeln("Box 2:\t", box);
                string match;
                for (auto i = 0; i < currentBox.length; i++) {
                    if (currentBox[i] == box[i]) {
                        match ~= currentBox[i];
                    }
                }
                writeln("Matching:\t", match);
                break outer;
            }
        }
    }
}
