module monomyst.math.vector2;

import core.simd;

/// Vector2 struct
struct Vector2
{
    private float4 v;

    /// The X component of a vector
    @property float x () { return v.array [0]; }
    /// ditto
    @property float x (float value) { return v.array [0] = value; }

    /// The Y component of a vector
    @property float y () { return v.array [1]; }
    /// ditto
    @property float y (float value) { return v.array [1] = value; }

    /// Constructs a Vector3 using X, Y and Z components
    this (float x, float y)
    {
        this.x = x;
        this.y = y;
    }

    /// Negates all the components of the vector
    void negate ()
    {
        v = -v;
    }

    /// Adds two vectors together
    void add (const Vector2 b)
    {
        v += b.v;
    }
}

unittest
{
    Vector2 vector = Vector2 (43, 56);
    assert (vector.x == 43 && vector.y == 56);

    vector.negate ();
    assert (vector.x == -43 && vector.y == -56);
    vector.negate ();
}