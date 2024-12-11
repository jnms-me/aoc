module day09.part2;

import std.algorithm : swap;
import std.conv : to;
import std.format : formattedRead;
import std.range : enumerate, isBidirectionalRange;
import std.stdio : readln, stdin, writeln;

struct File
{
    long id, size;

    bool free() const
        => id == -1;
}

struct DList(T)
{
    struct Node
    {
        T payload;
        Node* prev, next;
    }

    Node* front, back;

    bool empty() const
        => front is null && back is null;

    void opOpAssign(string op : "~")(T value)
    {
        Node* node = new Node;
        node.payload = value;
        if (empty)
        {
            front = node;
            back = node;
        }
        else
        {
            back.next = node;
            node.prev = back;
            back = node;
        }
    }
}

DList!File readDisk()
{
    DList!File disk;
    foreach (i, c; readln)
    {
        long id = i % 2 == 0 ? i / 2 : -1;
        long size = [c].to!long;
        if (size > 0)
            disk ~= File(id, size);
    }
    return disk;
}

void compact(ref DList!File disk)
{
    DList!File.Node* l = disk.front;
    while (true)
    {
        while (l !is null && !l.payload.free)
            l = l.next;
        if (l is null)
            return;
        DList!File.Node* r = disk.back;
        while (l !is r && !(!r.payload.free && l.payload.size >= r.payload.size))
            r = r.prev;
        if (l !is r)
        {
            swap(l.payload, r.payload);
            if (l.payload.size < r.payload.size)
            {
                DList!File.Node* oldNext = l.next;
                DList!File.Node* node = new DList!File.Node;
                l.next = node;
                node.prev = l;
                node.next = oldNext;
                oldNext.prev = node;
                node.payload.id = -1;
                node.payload.size = r.payload.size - l.payload.size;
                r.payload.size = l.payload.size;
            }
        }
        l = l.next;
    }
}

long checksum(DList!File disk)
{
    long res;
    DList!File.Node* node = disk.front;
    int pos;
    while (node !is null)
    {
        if (!node.payload.free)
            foreach (_; 0 .. node.payload.size)
                res += pos++ * node.payload.id;
        else
            pos += node.payload.size;
        node = node.next;
    }
    return res;
}

void solve()
{
    DList!File disk = readDisk;
    disk.compact;
    disk.checksum.writeln;
}
