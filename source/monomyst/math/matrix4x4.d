module monomyst.math.matrix4x4;

import core.simd;

/// Represents a 4x4 matrix
///
/// [r0c0, r0c1, r0c2, r0c3]
///
/// [r1c0, r1c1, r1c2, r1c3]
///
/// [r2c0, r2c1, r2c2, r2c3]
///
/// [r3c0, r3c1, r3c2, r3c3]
struct Matrix4x4
{
    private float4 v1;
    private float4 v2;
    private float4 v3;
    private float4 v4;

    @property float r0c0 () { return v1.array [0]; }
    @property float r0c0 (float value) { return v1.array [0] = value; }

    @property float r0c1 () { return v1.array [1]; }
    @property float r0c1 (float value) { return v1.array [1] = value; }

    @property float r0c2 () { return v1.array [2]; }
    @property float r0c2 (float value) { return v1.array [2] = value; }

    @property float r0c3 () { return v1.array [3]; }
    @property float r0c3 (float value) { return v1.array [3] = value; }

    @property float r1c0 () { return v2.array [0]; }
    @property float r1c0 (float value) { return v2.array [0] = value; }

    @property float r1c1 () { return v2.array [1]; }
    @property float r1c1 (float value) { return v2.array [1] = value; }

    @property float r1c2 () { return v2.array [2]; }
    @property float r1c2 (float value) { return v2.array [2] = value; }

    @property float r1c3 () { return v2.array [3]; }
    @property float r1c3 (float value) { return v2.array [3] = value; }

    @property float r2c0 () { return v3.array [0]; }
    @property float r2c0 (float value) { return v3.array [0] = value; }

    @property float r2c1 () { return v3.array [1]; }
    @property float r2c1 (float value) { return v3.array [1] = value; }

    @property float r2c2 () { return v3.array [2]; }
    @property float r2c2 (float value) { return v3.array [2] = value; }

    @property float r2c3 () { return v3.array [3]; }
    @property float r2c3 (float value) { return v3.array [3] = value; }

    @property float r3c0 () { return v4.array [0]; }
    @property float r3c0 (float value) { return v4.array [0] = value; }

    @property float r3c1 () { return v4.array [1]; }
    @property float r3c1 (float value) { return v4.array [1] = value; }

    @property float r3c2 () { return v4.array [2]; }
    @property float r3c2 (float value) { return v4.array [2] = value; }

    @property float r3c3 () { return v4.array [3]; }
    @property float r3c3 (float value) { return v4.array [3] = value; }
}

unittest
{
    assert (Matrix4x4.sizeof == 64);
}