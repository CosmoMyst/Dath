module monomyst.math.matrix2;

import monomyst.math.vector2;
import inteli.xmmintrin;

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

    Matrix2 mat = Matrix2.zero;

    assert (mat.r0c0 == 0 && mat.r0c1 == 0 &&
            mat.r1c0 == 0 && mat.r1c1 == 0);

    /++ +++++++++++++++++++++++++++++++++++++++++++ +/

    Matrix2 mat2 = Matrix2 (54, 34, 15, 57);
    Vector2 v = Vector2 (43, -48);
    Vector2 r = mat2 * v;
    assert (r.x == 690 && r.y == -2091);
}