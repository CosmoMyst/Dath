module monomyst.math.vector3;

import inteli.xmmintrin;

version (unittest) import monomyst.math.bassert;

/// Vector3 struct
struct Vector3
{
    package float [4] v;

    /// The X component of a vector
    @property float x () { return v [0]; }
    /// ditto
    @property float x (float value) { return v [0] = value; }

    /// The Y component of a vector
    @property float y () { return v [1]; }
    /// ditto
    @property float y (float value) { return v [1] = value; }

    /// The Z  component of a vector
    @property float z () { return v [2]; }
    /// ditto
    @property float z (float value) { return v [2] = value; }

    /// Constructs a Vector3 using X, Y and Z components
    this (float x, float y, float z)
    {
        this.x = x;
        this.y = y;
        this.z = z;
        v [3] = 0;
    }

    /++
        Zero Vector3 (0, 0, 0)
    +/
    static Vector3 zero = Vector3 (0, 0, 0);

    /++
        Calculates a dot product of two vectors.
        --------------------
        (a.x * b.x) + (a.y * b.y) + (a.z * b.z)
        --------------------
    +/
    static float dot (Vector3 a, Vector3 b)
    {
        // TODO: Package intel-intrinsics doesn't support this yet since this is SSE4.1
        // return _mm_cvtss_f32 (_mm_dp_ps (a.v, b.v, 0x71));

        return a.x * b.x + a.y * b.y + a.z * b.z;
    }
}

unittest
{
    Vector3 vector = Vector3.zero;

    assert (vector.x == 0 && vector.y == 0 && vector.z == 0);

    vector = Vector3 (43, 56, 13);
    assert (vector.x == 43 && vector.y == 56 && vector.z == 13);
}

unittest
{
    Vector3 a = Vector3 (2, 5, 3);
    Vector3 b = Vector3 (7, 4, 9);
    immutable float res = Vector3.dot (a, b);
    bassert (res, 61);
}