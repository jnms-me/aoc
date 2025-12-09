module day01.part2;

import std;

void solve()
{
    int state = 50;
    int password;

    void moveRight(int amount)
    {
    }

    foreach (line; stdin.byLine)
    {
        char direction;
        int amount;
        line.formattedRead!"%c%d"(direction, amount);
        state += direction == 'R' ? amount : -amount;
        while (state < 0) state += 100;
        while (99 < state) state -= 100;
        if (state == 0) password++;
    }
    password.writeln;
}
