module dath.rect;

public alias Rect = RectImpl!float;
public alias RectI = RectImpl!int;

/++
 + rectangle definition, origin at upper left.
 +/
struct RectImpl(T) {
    T x;
    T y;
    T w;
    T h;
}

bool intersects(T)(RectImpl!T a, RectImpl!T b) @nogc
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

unittest
{
    Rect a = Rect(0, 0, 10, 10);
    Rect b = Rect(5, 5, 10, 10);
    assert(intersects(a, b));
}
