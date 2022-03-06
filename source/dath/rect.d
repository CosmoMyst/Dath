module dath.rect;

version(unittest) import fluent.asserts;

import std.traits;
import dath.vector;

public alias Rectf = Rect!float;
public alias Rectd = Rect!double;
public alias Recti = Rect!int;
public alias Rectu = Rect!uint;

/++
 + Rectangle definition, origin at upper left.
 +/
public struct Rect(T) if (isNumeric!T)
{
    union
    {
        T[4] v;

        struct
        {
            T x;
            T y;
            T w;
            T h;
        }

        struct
        {
            Vec!(T, 2) position;
            Vec!(T, 2) size;
        }
    }

    public this(T value) @nogc pure nothrow
    {
        v[] = value;
    }

    public this(T x, T y, T w, T h) @nogc pure nothrow
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    public this(T x, T y, Vec!(T, 2) size) @nogc pure nothrow
    {
        this.x = x;
        this.y = y;
        this.size = size;
    }

    public this (Vec!(T, 2) position, T w, T h) @nogc pure nothrow
    {
        this.position = position;
        this.w = w;
        this.h = h;
    }

    public this (Vec!(T, 2) position, Vec!(T, 2) size) @nogc pure nothrow
    {
        this.position = position;
        this.size = size;
    }
}

/++ 
 + Checks if two rectangles intersect.
 +/
public bool intersects(T)(const Rect!T a, const Rect!T b) @nogc pure nothrow
{
    if (a.x < b.x + b.w &&
        a.x + a.w > b.x &&
        a.y < b.y + b.h &&
        a.y + a.h > b.y)
    {
        return true;
    }

    return false;
}

@("Rect creation and intersection")
unittest
{
    const a = Rectf(0, 0, 10, 10);
    const b = Rectf(5, 5, 10, 10);

    intersects(a, b).should.equal(true);

    const r1 = Rectf(Vec2(10, 10), Vec2(5, 5));
    
    r1.should.equal(Rectf(10, 10, 5, 5));
}
