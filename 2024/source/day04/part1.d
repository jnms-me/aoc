module day04.part1;

import std.exception : enforce;
import std.format : f = format;
import std.range : enumerate;
import std.stdio : stdin, writeln;

@safe:

enum size_t ct_dim = 140;
enum string ct_needle = "XMAS";

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
            if (matrix[row][col] == ct_needle[0])
                count += castAllDims(row, col);
    writeln(count);
}

nothrow @nogc
uint castAllDims(size_t row, size_t col)
{
    uint count;
    foreach (yDir; [-1, 0, 1])
        foreach (xDir; [-1, 0, 1])
        {
            if (yDir == 0 && xDir == 0)
                continue;
            if (castOnce(row, col, yDir, xDir))
                count++;
        }
    return count;
}

nothrow @nogc
bool castOnce(size_t row, size_t col, int yDir, int xDir)
{
    if (row + yDir * (ct_needle.length - 1) >= ct_dim)
        return false;
    if (col + xDir * (ct_needle.length - 1) >= ct_dim)
        return false;
    foreach (i, c; ct_needle)
    {
        if (i == 0)
            continue;
        if (matrix[row + yDir * i][col + xDir * i] != c)
            return false;
    }
    return true;
}
