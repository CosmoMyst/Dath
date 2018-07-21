module monomyst.math.matrix2;

/++
    Matrix 2x2 structure
+/
struct Matrix2
{
    private float [4] v;

    @property float r0c0 () { return v[0]; }
    @property float r0c0 (float value) { return v[0] = value; }

    @property float r0c1 () { return v[1]; }
    @property float r0c1 (float value) { return v[1] = value; }

    @property float r1c0 () { return v[2]; }
    @property float r1c0 (float value) { return v[2] = value; }

    @property float r1c1 () { return v[3]; }
    @property float r1c1 (float value) { return v[3] = value; }

    /++
        Constructs a new Matrix 2x2
    +/
    this (float r0c0, float r0c1,
          float r1c0, float r1c1)
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
}

unittest
{
    assert (Matrix2.sizeof == 16);

    Matrix2 mat = Matrix2.zero;

    assert (mat.r0c0 == 0 && mat.r0c1 == 0 &&
            mat.r1c0 == 0 && mat.r1c1 == 0);
}