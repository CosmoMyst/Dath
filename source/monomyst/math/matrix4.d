module monomyst.math.matrix4;

version (unittest) import monomyst.math.bassert;

import inteli.xmmintrin;
import monomyst.math.vector3;

/// Represents a 4x4 matrix
///
/// [r0c0, r0c1, r0c2, r0c3]
///
/// [r1c0, r1c1, r1c2, r1c3]
///
/// [r2c0, r2c1, r2c2, r2c3]
///
/// [r3c0, r3c1, r3c2, r3c3]
struct Matrix4
{
    private float [4] v1;
    private float [4] v2;
    private float [4] v3;
    private float [4] v4;

    @property float r0c0 () const { return v1 [0]; }
    @property float r0c0 (float value) { return v1 [0] = value; }

    @property float r0c1 () const { return v1 [1]; }
    @property float r0c1 (float value) { return v1 [1] = value; }

    @property float r0c2 () const { return v1 [2]; }
    @property float r0c2 (float value) { return v1 [2] = value; }

    @property float r0c3 () const { return v1 [3]; }
    @property float r0c3 (float value) { return v1 [3] = value; }

    @property float r1c0 () const { return v2 [0]; }
    @property float r1c0 (float value) { return v2 [0] = value; }

    @property float r1c1 () const { return v2 [1]; }
    @property float r1c1 (float value) { return v2 [1] = value; }

    @property float r1c2 () const { return v2 [2]; }
    @property float r1c2 (float value) { return v2 [2] = value; }

    @property float r1c3 () const { return v2 [3]; }
    @property float r1c3 (float value) { return v2 [3] = value; }

    @property float r2c0 () const { return v3 [0]; }
    @property float r2c0 (float value) { return v3 [0] = value; }

    @property float r2c1 () const { return v3 [1]; }
    @property float r2c1 (float value) { return v3 [1] = value; }

    @property float r2c2 () const { return v3 [2]; }
    @property float r2c2 (float value) { return v3 [2] = value; }

    @property float r2c3 () const { return v3 [3]; }
    @property float r2c3 (float value) { return v3 [3] = value; }

    @property float r3c0 () const { return v4 [0]; }
    @property float r3c0 (float value) { return v4 [0] = value; }

    @property float r3c1 () const { return v4 [1]; }
    @property float r3c1 (float value) { return v4 [1] = value; }

    @property float r3c2 () const { return v4 [2]; }
    @property float r3c2 (float value) { return v4 [2] = value; }

    @property float r3c3 () const { return v4 [3]; }
    @property float r3c3 (float value) { return v4 [3] = value; }

    /++
        Constrcuts a new Matrix 4x4
    +/
    this (float r0c0, float r0c1, float r0c2, float r0c3,
          float r1c0, float r1c1, float r1c2, float r1c3,
          float r2c0, float r2c1, float r2c2, float r2c3,
          float r3c0, float r3c1, float r3c2, float r3c3)
    {
        this.r0c0 = r0c0;
        this.r0c1 = r0c1;
        this.r0c2 = r0c2;
        this.r0c3 = r0c3;
        this.r1c0 = r1c0;
        this.r1c1 = r1c1;
        this.r1c2 = r1c2;
        this.r1c3 = r1c3;
        this.r2c0 = r2c0;
        this.r2c1 = r2c1;
        this.r2c2 = r2c2;
        this.r2c3 = r2c3;
        this.r3c0 = r3c0;
        this.r3c1 = r3c1;
        this.r3c2 = r3c2;
        this.r3c3 = r3c3;
    }

    /++
        Identity Matrix4

        [1, 0, 0, 0]
        
        [0, 1, 0, 0]
        
        [0, 0, 1, 0]
        
        [0, 0, 0, 1]
    +/
    static Matrix4 identity = Matrix4 (1, 0, 0, 0,
                                       0, 1, 0, 0,
                                       0, 0, 1, 0,
                                       0, 0, 0, 1);

    /++
        Zero Matrix4

        [0, 0, 0, 0]
        
        [0, 0, 0, 0]
        
        [0, 0, 0, 0]
        
        [0, 0, 0, 0]
    +/
    static Matrix4 zero = Matrix4 (0, 0, 0, 0,
                                   0, 0, 0, 0,
                                   0, 0, 0, 0,
                                   0, 0, 0, 0);

    /++
        Rotates a matrix on the x axis by the angle

        Params:
            angle = Angle in radians
    +/
    static Matrix4 rotateX (float angle)
    {
        import std.math : sin, cos;

        immutable float cosAngle = cos (angle);
        immutable float sinAngle = sin (angle);

        return Matrix4 (1, 0,        0,         0,
                        0, cosAngle, -sinAngle, 0,
                        0, sinAngle, cosAngle,  0,
                        0, 0,        0,         1);
    }

    /++
        Rotates a matrix on the y axis by the angle

        Params:
            angle = Angle in radians
    +/
    static Matrix4 rotateY (float angle)
    {
        import std.math : sin, cos;

        immutable float cosAngle = cos (angle);
        immutable float sinAngle = sin (angle);

        return Matrix4 (cosAngle,  0, sinAngle, 0,
                        0,         1, 0,        0,
                        -sinAngle, 0, cosAngle, 0,
                        0,         0, 0,        1);
    }

    /++
        Rotates a matrix on the z axis by the angle

        Params:
            angle = Angle in radians
    +/
    static Matrix4 rotateZ (float angle)
    {
        import std.math : sin, cos;

        immutable float cosAngle = cos (angle);
        immutable float sinAngle = sin (angle);

        return Matrix4 (cosAngle, -sinAngle, 0, 0,
                        sinAngle, cosAngle,  0, 0,
                        0,        0,         1, 0,
                        0,        0,         0, 1);
    }

    /++
        Creates a look at matrix.

        Params:
            cameraPosition = A Vector3 struct that defines the camera position. This value is used in translation.
            cameraTarget   = A Vector3 struct that defines the camera look at target.
            cameraUpVector = A Vector3 struct that defines the up direction of the current world.
    +/
    static Matrix4 lookAt (Vector3 cameraPosition, Vector3 cameraTarget, Vector3 cameraUpVector)
    {
        Vector3 zaxis = (cameraTarget - cameraPosition).normalize;
        Vector3 xaxis = Vector3.cross (cameraUpVector, zaxis).normalize;
        Vector3 yaxis = Vector3.cross (zaxis, xaxis);

        return Matrix4 (xaxis.x,                               yaxis.x,                              zaxis.x,                             0,  // stfu
                        xaxis.y,                               yaxis.y,                              zaxis.y,                             0,  // stfu
                        xaxis.z,                               yaxis.z,                              zaxis.z,                             0,  // stfu
                        -Vector3.dot (xaxis, cameraPosition), -Vector3.dot (yaxis, cameraPosition), -Vector3.dot (zaxis, cameraPosition), 1); // stfu
    }
    unittest
    {
        Matrix4 lookat = Matrix4.lookAt (Vector3 (0, 3, -5), Vector3 (0, 0, 0), Vector3 (0, 1, 0));

        bassert (lookat.r0c0, 1.0f);
        bassert (lookat.r0c1, 0.0f);
        bassert (lookat.r0c2, 0.0f);
        bassert (lookat.r0c3, 0.0f);
        bassert (lookat.r1c0, 0.0f);
        bassertApprox (lookat.r1c1, 0.857493f);
        bassertApprox (lookat.r1c2, -0.514496f);
        bassert (lookat.r1c3, 0.0f);
        bassert (lookat.r2c0, 0.0f);
        bassertApprox (lookat.r2c1, 0.514496f);
        bassertApprox (lookat.r2c2, 0.857493f);
        bassert (lookat.r2c3, 0.0f);
        bassert (lookat.r3c0, 0.0f);
        bassert (lookat.r3c1, 0.0f);
        bassertApprox (lookat.r3c2, 5.83095f);
        bassert (lookat.r3c3, 1.0f);
    }

    /++
        Gets the text representation of the matrix.
    +/
    string toString () const
    {
        import std.format : format;

        return format ("%s, %s, %s, %s,\n%s, %s, %s, %s,\n%s, %s, %s, %s,\n%s, %s, %s, %s",
                      r0c0, r0c1, r0c2, r0c3, r1c0, r1c1, r1c2, r1c3, r2c0, r2c1, r2c2, r2c3, r3c0, r3c1, r3c2, r3c3);
    }
}

unittest
{
    assert (Matrix4.sizeof == 64);
    
    Matrix4 mat = Matrix4.zero;

    assert (mat.r0c0 == 0 && mat.r0c1 == 0 && mat.r0c2 == 0 && mat.r0c3 == 0 &&
            mat.r1c0 == 0 && mat.r1c1 == 0 && mat.r1c2 == 0 && mat.r1c3 == 0 &&
            mat.r2c0 == 0 && mat.r2c1 == 0 && mat.r2c2 == 0 && mat.r2c3 == 0 &&
            mat.r3c0 == 0 && mat.r3c1 == 0 && mat.r3c2 == 0 && mat.r3c3 == 0);

    Matrix4 identityMat = Matrix4.identity;

    assert (identityMat.r0c0 == 1 && identityMat.r0c1 == 0 && identityMat.r0c2 == 0 && identityMat.r0c3 == 0 &&
            identityMat.r1c0 == 0 && identityMat.r1c1 == 1 && identityMat.r1c2 == 0 && identityMat.r1c3 == 0 &&
            identityMat.r2c0 == 0 && identityMat.r2c1 == 0 && identityMat.r2c2 == 1 && identityMat.r2c3 == 0 &&
            identityMat.r3c0 == 0 && identityMat.r3c1 == 0 && identityMat.r3c2 == 0 && identityMat.r3c3 == 1);
}

unittest
{
    import std.math : PI;

    Matrix4 rm1 = Matrix4.rotateX (0);
    bassert (rm1.r0c0, 1);
    bassertApprox (rm1.r0c1, 0);
    bassertApprox (rm1.r0c2, 0);
    bassertApprox (rm1.r0c3, 0);

    bassertApprox (rm1.r1c0, 0);
    bassert (rm1.r1c1, 1);
    bassertApprox (rm1.r1c2, 0);
    bassertApprox (rm1.r1c3, 0);

    bassertApprox (rm1.r2c0, 0);
    bassertApprox (rm1.r2c1, 0);
    bassert (rm1.r2c2, 1);
    bassertApprox (rm1.r2c3, 0);

    bassertApprox (rm1.r3c0, 0);
    bassertApprox (rm1.r3c1, 0);
    bassertApprox (rm1.r3c2, 0);
    bassert (rm1.r3c3, 1);

    Matrix4 rm2 = Matrix4.rotateX (PI);
    bassert (rm2.r0c0, 1);
    bassertApprox (rm2.r0c1, 0);
    bassertApprox (rm2.r0c2, 0);
    bassertApprox (rm2.r0c3, 0);

    bassertApprox (rm2.r1c0, 0);
    bassert (rm2.r1c1, -1);
    bassertApprox (rm2.r1c2, 0);
    bassertApprox (rm2.r1c3, 0);

    bassertApprox (rm2.r2c0, 0);
    bassertApprox (rm2.r2c1, 0);
    bassert (rm2.r2c2, -1);
    bassertApprox (rm2.r2c3, 0);

    bassertApprox (rm2.r3c0, 0);
    bassertApprox (rm2.r3c1, 0);
    bassertApprox (rm2.r3c2, 0);
    bassert (rm2.r3c3, 1);
}
