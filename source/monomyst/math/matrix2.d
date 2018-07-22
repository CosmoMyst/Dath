module monomyst.math.matrix2;

import inteli.xmmintrin;
import monomyst.math.vector2;

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

        return Matrix2 (cos (angle), -sin (angle),
                        sin (angle),  cos (angle));
    }

    Vector2 opBinary (string op) (in Vector2 vec) nothrow @nogc if (op == "*")
    {
        // TODO: Use SIMD... somehow...

        Vector2 temp;
        Vector2 param = vec;

        temp.x = param.x * r0c0 + param.y * r0c1;
        temp.y = param.x * r1c0 + param.y * r1c1;

        return temp;
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

// TODO: Move this to a separate library
void equals (float value, float result)
{
    import std.string : format;

    assert (value == result, format ("Expected %s, got %s", result, value));
}

// TODO: Move this to a separate library
void approxEquals (float value, float result)
{
    import std.math : approxEqual;
    import std.format : format;

    assert (approxEqual (value, result), format ("Expected %s, got %s", result, value));
}

unittest
{
    import std.math : PI;

    Matrix2 rm1 = Matrix2.rotate (0);
    equals       (rm1.r0c0, 1);
    approxEquals (rm1.r0c1, 0);
    approxEquals (rm1.r1c0, 0);
    equals       (rm1.r1c1, 1);

    Matrix2 rm2 = Matrix2.rotate (PI);
    equals       (rm2.r0c0, -1);
    approxEquals (rm2.r0c1, 0);
    approxEquals (rm2.r1c0, 0);
    equals       (rm2.r1c1, -1);

    Matrix2 rm3 = Matrix2.rotate (PI / 2);
    approxEquals (rm3.r0c0, 0);
    equals       (rm3.r0c1, -1);
    equals       (rm3.r1c0, 1);
    approxEquals (rm3.r1c1, 0);

    Matrix2 rm4 = Matrix2.rotate (PI / 4);
    equals (rm4.r0c0, 0.70710678118f);
    equals (rm4.r0c1, -0.70710678118f);
    equals (rm4.r1c0, 0.70710678118f);
    equals (rm4.r1c1, 0.70710678118f);

    Matrix2 rm5 = Matrix2.rotate (-PI / 4);
    equals (rm5.r0c0, 0.70710678118f);
    equals (rm5.r0c1, 0.70710678118f);
    equals (rm5.r1c0, -0.70710678118f);
    equals (rm5.r1c1, 0.70710678118f);

    Matrix2 rm6 = Matrix2.rotate (PI / 3);
    approxEquals (rm6.r0c0, 0.5f);
    approxEquals (rm6.r0c1, -0.86602540378f);
    approxEquals (rm6.r1c0, 0.86602540378f);
    approxEquals (rm6.r1c1, 0.5f);
}