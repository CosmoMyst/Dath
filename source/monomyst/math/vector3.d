module monomyst.math.vector3;

import core.simd;

/// Vector3 struct
struct Vector3
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

    /// The Z  component of a vector
    @property float z () { return v.array [2]; }
    /// ditto
    @property float z (float value) { return v.array [2] = value; }

    /// Constructs a Vector3 using X, Y and Z components
    this (float x, float y, float z)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /// Negates all the components of the vector
    void negate ()
    {
        v = -v;
    }

    /// Adds two vectors together
    void add (const Vector3 b)
    {
        v += b.v;
    }
}

unittest
{
    Vector3 vector = Vector3 (43, 56, 13);
    assert (vector.x == 43 && vector.y == 56 && vector.z == 13);

    vector.negate ();
    assert (vector.x == -43 && vector.y == -56 && vector.z == -13);
    vector.negate ();
}