module cosmomyst.math.vector2;

import inteli.xmmintrin;

/// Vector2 struct
struct Vector2
{
    package float [4] v;

    /// The X component of a vector
    @property float x () nothrow @nogc { return v [0]; }
    /// ditto
    @property float x (float value) nothrow @nogc { return v [0] = value; }

    /// The Y component of a vector
    @property float y () nothrow @nogc { return v [1]; }
    /// ditto
    @property float y (float value) nothrow @nogc { return v [1] = value; }

    /// Constructs a Vector3 using X, Y and Z components
    this (float x, float y) nothrow @nogc
    {
        this.x = x;
        this.y = y;
        v [2] = 0;
        v [3] = 0;
    }

    Vector2 opBinary (string op) (in float scalar) @nogc if (op == "*")
    {
        Vector2 temp;

        __m128 mmvalue = _mm_loadu_ps (v.ptr);
        __m128 res = _mm_mul_ps (mmvalue, scalar);
        
        temp.x = res [0];
        temp.y = res [1];

        return temp;
    }

    Vector2 opBinary (string op) (in int scalar) @nogc if (op == "*")
    {
        return this * cast (float) scalar;
    }
}

unittest
{
    Vector2 vector = Vector2 (43, 56);
    assert (vector.x == 43 && vector.y == 56);

    /++ ++++++++++++++++++++++++++++++++++++++ +/

    Vector2 v = Vector2 (2, 8);
    Vector2 res = v * 4;
    assert (res.x == 8 && res.y == 32);
}