module monomyst.math.vector3;

import inteli.xmmintrin;
import inteli.emmintrin;

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

        // return a.x * b.x + a.y * b.y + a.z * b.z;

        __m128 v1 = _mm_loadu_ps (a.v.ptr);
        __m128 v2 = _mm_loadu_ps (b.v.ptr);

        __m128 res = _mm_mul_ps (v1, v2);
        return res [0] + res [1] + res [2];
    }
    unittest
    {
        Vector3 a = Vector3 (2, 5, 3);
        Vector3 b = Vector3 (7, 4, 9);
        immutable float res = Vector3.dot (a, b);
        bassert (res, 61);
    }

    /++
        Get the length of the vector.
        --------------------
        sqrt (x^2 + y^2 + z^2)
        --------------------
    +/
    float length ()
    {
        // TODO: Package intel-intrinsics doesn't support this yet since this is SSE4.1
        // return _mm_cvtss_f32 (_mm_sqrt_ss (_mm_dp_ps (v, v, 0x71)));

        __m128 v1 = _mm_loadu_ps (v.ptr);

        __m128 res = _mm_mul_ps (v1, v1);

        immutable float sum = res [0] + res [1] + res [2];

        return _mm_cvtss_f32 (_mm_sqrt_ss (sum));
    }
    unittest
    {
        Vector3 v1 = Vector3 (5, 2, 6);
        immutable float len = v1.length;
        bassert (len, 8.06225774829855f);
    }
    /++
        Calculates a corss product of two vectors.
        --------------------
        c.x = a.y * b.z − a.z * b.y
        c.y = a.z * b.x − a.x * b.z
        c.z = a.x * b.y − a.y * b.x
        --------------------
    +/
    static Vector3 cross (Vector3 a, Vector3 b)
    {
        __m128 v1 = _mm_loadu_ps (a.v.ptr);
        __m128 v2 = _mm_loadu_ps (b.v.ptr);

        __m128 res = _mm_sub_ps
        (
            _mm_mul_ps (_mm_shuffle_ps! (_MM_SHUFFLE (3, 0, 2, 1)) (v1, v1),
                        _mm_shuffle_ps! (_MM_SHUFFLE (3, 1, 0, 2)) (v2, v2)),
            _mm_mul_ps (_mm_shuffle_ps! (_MM_SHUFFLE (3, 1, 0, 2)) (v1, v1),
                        _mm_shuffle_ps! (_MM_SHUFFLE (3, 0, 2, 1)) (v2, v2))
        );

        return Vector3 (res [0], res [1], res [2]);
    }
    unittest
    {
        Vector3 a = Vector3 (2, 3, 4);
        Vector3 b = Vector3 (5, 6, 7);
        Vector3 res = Vector3.cross (a, b);
        bassert (res.x, -3);
        bassert (res.y, 6);
        bassert (res.z, -3);
    }
}

unittest
{
    Vector3 vector = Vector3.zero;

    assert (vector.x == 0 && vector.y == 0 && vector.z == 0);

    vector = Vector3 (43, 56, 13);
    assert (vector.x == 43 && vector.y == 56 && vector.z == 13);
}