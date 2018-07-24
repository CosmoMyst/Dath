module monomyst.math.matrix2;

import inteli.xmmintrin;
import monomyst.math.vector2;

version (unittest) import monomyst.math.bassert;

/++
    Matrix 2x2 structure
+/
struct Matrix2
{
    private float [4] v;

    @property float r0c0 () nothrow @nogc { return v[0]; }
    @property float r0c0 (float value) nothrow @nogc { return v[0] = value; }

    @property float r0c1 () nothrow @nogc { return v[1]; }
    @property float r0c1 (float value) nothrow @nogc { return v[1] = value; }

    @property float r1c0 () nothrow @nogc { return v[2]; }
    @property float r1c0 (float value) nothrow @nogc { return v[2] = value; }

    @property float r1c1 () nothrow @nogc { return v[3]; }
    @property float r1c1 (float value) nothrow @nogc { return v[3] = value; }

    /++
        Constructs a new Matrix 2x2
    +/
    this (float r0c0, float r0c1,
          float r1c0, float r1c1) nothrow @nogc
    {
        this.r0c0 = r0c0;
        this.r0c1 = r0c1;
        this.r1c0 = r1c0;
        this.r1c1 = r1c1;
    }

    /++
        Matrix 2x2 that has all values set to 0

        [0, 0]

        [0, 0]
    +/
    static Matrix2 zero = Matrix2 (0, 0,
                                   0, 0);

    /++
        Params:
            angle = How much to rotate the matrix (in radians)
    +/
    static Matrix2 rotate (float angle)
    {
        import std.math : cos, sin;

        const float cosres = cos (angle);
        const float sinres = sin (angle);

        return Matrix2 (cosres, -sinres,
                        sinres,  cosres);
    }

    Vector2 opBinary (string op) (in Vector2 vec) nothrow @nogc if (op == "*")
    {
        // TODO: Use SIMD... somehow...

        Vector2 param = vec;

        return Vector2 (param.x * r0c0 + param.y * r0c1, param.x * r1c0 + param.y * r1c1);
    }
}

unittest
{
    assert (Matrix2.sizeof == 16);
}

unittest
{
    Matrix2 mat = Matrix2.zero;

    assert (mat.r0c0 == 0 && mat.r0c1 == 0 &&
            mat.r1c0 == 0 && mat.r1c1 == 0);
}

unittest
{
    Matrix2 mat2 = Matrix2 (54, 34, 15, 57);
    Vector2 v = Vector2 (43, -48);
    Vector2 r = mat2 * v;
    assert (r.x == 690 && r.y == -2091);
}

unittest
{
    import std.math : PI, sqrt;

    Matrix2 rm1 = Matrix2.rotate (0);
    bassert       (rm1.r0c0, 1);
    bassertApprox (rm1.r0c1, 0);
    bassertApprox (rm1.r1c0, 0);
    bassert       (rm1.r1c1, 1);

    Matrix2 rm2 = Matrix2.rotate (PI);
    bassert       (rm2.r0c0, -1);
    bassertApprox (rm2.r0c1, 0);
    bassertApprox (rm2.r1c0, 0);
    bassert       (rm2.r1c1, -1);

    Matrix2 rm3 = Matrix2.rotate (PI / 2);
    bassertApprox (rm3.r0c0, 0);
    bassert       (rm3.r0c1, -1);
    bassert       (rm3.r1c0, 1);
    bassertApprox (rm3.r1c1, 0);

    Matrix2 rm4 = Matrix2.rotate (PI / 4);
    bassert (rm4.r0c0, sqrt (2.0f) / 2.0f);
    bassert (rm4.r0c1, -sqrt (2.0f) / 2.0f);
    bassert (rm4.r1c0, sqrt (2.0f) / 2.0f);
    bassert (rm4.r1c1, sqrt (2.0f) / 2.0f);

    Matrix2 rm5 = Matrix2.rotate (-PI / 4);
    bassert (rm5.r0c0, sqrt (2.0f) / 2.0f);
    bassert (rm5.r0c1, sqrt (2.0f) / 2.0f);
    bassert (rm5.r1c0, -sqrt (2.0f) / 2.0f);
    bassert (rm5.r1c1, sqrt (2.0f) / 2.0f);

    Matrix2 rm6 = Matrix2.rotate (PI / 3);
    bassertApprox (rm6.r0c0, 0.5f);
    bassertApprox (rm6.r0c1, -sqrt (3.0f) / 2.0f);
    bassertApprox (rm6.r1c0, sqrt (3.0f) / 2.0f);
    bassertApprox (rm6.r1c1, 0.5f);
}