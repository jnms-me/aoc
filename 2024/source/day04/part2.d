module day04.part2;

import std.algorithm : sort;
import std.exception : enforce;
import std.format : f = format;
import std.range : enumerate;
import std.stdio : stdin, writeln;

@safe:

enum size_t ct_dim = 140;

char[ct_dim][ct_dim] matrix;

@trusted
void solve()
{
    foreach (i, line; stdin.byLine.enumerate)
    {
        enforce(line.length == ct_dim, f!"Expected input of %ux%u"(ct_dim, ct_dim));
        matrix[i] = line[];
    }

    uint count;
    foreach (row; 0 .. ct_dim)
        foreach (col; 0 .. ct_dim)
            if (matrix[row][col] == 'A')
                if (checkX(row, col))
                    count += checkX(row, col);
    writeln(count);
}

nothrow @nogc
bool checkX(size_t row, size_t col)
{
    foreach (dim; [row, col])
        if (dim == 0 || dim == ct_dim - 1)
            return false;

    char[2] leg1 = [matrix[row - 1][col - 1], matrix[row + 1][col + 1]];
    char[2] leg2 = [matrix[row + 1][col - 1], matrix[row - 1][col + 1]];

    return checkLeg(leg1) && checkLeg(leg2);
}

nothrow @nogc
bool checkLeg(char[2] leg)
    => leg == "SM" || leg == "MS";
