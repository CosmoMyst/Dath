module dath.rect;

import std.traits;

public alias Rectf = Rect!float;
public alias Rectd = Rect!double;
public alias Recti = Rect!int;
public alias Rectu = Rect!uint;

/++
 + Rectangle definition, origin at upper left.
 +/
public struct Rect(T) if (isNumeric!T)
{
    T x;
    T y;
    T w;
    T h;
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
    Rectf a = Rectf(0, 0, 10, 10);
    Rectf b = Rectf(5, 5, 10, 10);
    assert(intersects(a, b));
}
