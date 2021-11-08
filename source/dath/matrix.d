module dath.matrix;

import dath.core;
import dath.vector;

alias Mat2 = Mat!2;
alias Mat3 = Mat!3;
alias Mat4 = Mat!4;

/++
 + a square NxN matrix
 +/
struct Mat(ulong n) if (n >= 2)
{
    union
    {
        float[n*n] v; // all values
        float[n][n] c; // all components
    }

    @nogc this(T...)(T args) pure nothrow
    {
        import std.traits : isNumeric;

        static foreach (arg; args)
        {
            static assert(isNumeric!(typeof(arg)), "all values must be numeric");
        }

        static assert(args.length > 0, "no args provided");

        static assert(args.length == 1 || args.length == n*n, "number of args must be ither 1 or N*N");

        static if (args.length == 1)
        {
            static foreach (i; 0..n*n)
            {
                v[i] = args[0];
            }
        }
        else
        {
            static foreach (i, arg; args)
            {
                v[i] = arg;
            }
        }
    }

    /++
     + get the value at [i, j]
     +/
    @nogc float opIndex(int i, int j) pure const nothrow
    {
        return c[i][j];
    }

    /++
     + set the value at [i, j]
     +/
    @nogc float opIndexAssign(float value, int i, int j) pure nothrow
    {
        return c[i][j] = value;
    }

    /++
     + returns this matrix * scalar
     +/
    @nogc auto opBinary(string s) (const float scalar) pure const nothrow if (s == "*")
    {
        Mat res;

        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < n; j++)
            {
                res[i, j] = this[i, j] * scalar;
            }
        }

        return res;
    }

    /++
     + returns this matrix * scalar
     +/
    @nogc void opOpAssign(string s) (const float scalar) pure nothrow if (s == "*")
    {
        auto res = this * scalar;
        this.v = res.v;
    }

    /++
     + returns this matrix * vector
     +/
    @nogc auto opBinary(string s) (const Vec!n vector) pure const nothrow if (s == "*")
    {
         Vec!n res;

         for (int i = 0; i < n; i++)
         {
             float sum = 0f;
             for (int j = 0; j < n; j++)
             {
                 sum += this[i, j] * vector[j];
             }
             res[i] = sum;
         }

         return res;
    }

    /++
     + returns this matrix * matrix
     +/
    @nogc auto opBinary(string s) (const Mat!n other) pure const nothrow if (s == "*")
    {
        Mat!n res;

        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < n; j++)
            {
                float sum = 0f;
                for (int k = 0; k < n; k++)
                {
                    sum += this[i, k] * other[k, j];
                }
                res[i, j] = sum;
            }
        }

        return res;
    }

    /++
     + returns this matrix * matrix
     +/
    @nogc void opOpAssign (string s) (const Mat!n other) pure nothrow if (s == "*")
    {
        auto res = this * other;
        this.v = res.v;
    }

    /++
     + returns sum or sub of two matrices
     +/
     @nogc auto opBinary(string s) (const Mat!n other) pure const nothrow if (s == "+" || s == "-")
     {
        Mat!n res;

        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < n; j++)
            {
                mixin("res[i, j] = this[i, j] " ~ s ~ " other[i, j];");
            }
        }

        return res;
     }

    /++
     + internal data as a pointer, use for sending data to shaders.
     +/
    @nogc auto ptr() pure nothrow const
    {
        return v.ptr;
    }
}

/++
 + creates an identity matrix
 +/
@nogc Mat!n matIdentity(ulong n)() pure nothrow
{
    Mat!n res;
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            res[i, j] = i == j ? 1f : 0f;
        }
    }
    return res;
}

/++
 + creates a scaling matrix
 +/
@nogc Mat!n matScaling(ulong n)(Vec!(n-1) v) pure nothrow
{
    auto res = matIdentity!n();
    for (int i = 0; i + 1 < n; i++)
    {
        res[i, i] = v[i];
    }
    return res;
}

/++
 + creates a rotation matrix, angle must be in radians
 +/
@nogc Mat4 matRotation(float angle, Vec3 axis) pure nothrow
{
    import std.math : sin, cos;

    auto res = matIdentity!4();
    float c = cos(angle);
    float c1 = 1 - c;
    float s = sin(angle);

    auto a = axis.normalized();

    res[0, 0] = a.x * a.x * c1 + c;
    res[0, 1] = a.x * a.y * c1 - a.z * s;
    res[0, 2] = a.x * a.z * c1 + a.y * s;
    res[1, 0] = a.y * a.x * c1 + a.z * s;
    res[1, 1] = a.y * a.y * c1 + c;
    res[1, 2] = a.y * a.z * c1 - a.x * s;
    res[2, 0] = a.z * a.x * c1 - a.y * s;
    res[2, 1] = a.z * a.y * c1 + a.x * s;
    res[2, 2] = a.z * a.z * c1 + c;

    return res;
}

/++
 + creates a translation matrix
 +/
@nogc auto matTranslation(ulong n)(Vec!(n-1) v) pure nothrow
{
    auto res = matIdentity!n();
    for (int i = 0; i + 1 < n; i++)
    {
        res[i, n-1] = res[i, n-1] + v[i];
    }
    return res;
}

/++
 + creates a look_at matrix
 +/
@nogc Mat4 matLookAt(Vec3 eye, Vec3 target, Vec3 up) pure nothrow
{
    Vec3 z = (eye - target).normalized();
    Vec3 x = vecCross(-up, z).normalized();
    Vec3 y = vecCross(z, -x);

    return Mat4(-x.x, -x.y, -x.z,  vecDot!3(x, eye),
                 y.x,  y.y,  y.z, -vecDot!3(y, eye),
                 z.x,  z.y,  z.z, -vecDot!3(z, eye),
                 0f,   0f,   0f,   1f);
}

/++
 + creates an orthographic projection matrix
 +/
@nogc Mat4 matOrthographic(float left, float right, float bottom, float top, float near, float far) pure nothrow
{
    float dx = right - left;
    float dy = top - bottom;
    float dz = far - near;

    float tx = -(right + left) / dx;
    float ty = -(top + bottom) / dy;
    float tz = -(far + near) / dz;

    return Mat4(2/dx, 0f,    0f,   tx,
                0f,   2/dy,  0f,   ty,
                0f,   0f,   -2/dz, tz,
                0f,   0f,    0f,   1f);
}

/++
 + creates a perspective projection matrix
 +/
@nogc Mat4 matPerspective(float fov_in_radians, float aspect, float near, float far) pure nothrow
{
    import std.math : tan;

    float f = 1 / tan(fov_in_radians / 2);
    float d = 1 / (near - far);

    return Mat4(f / aspect, 0f, 0f,               0f,
                0f,         f,  0f,               0f,
                0f,         0f, (far + near) * d, 2 * d * far * near,
                0f,         0f, -1f,              0f);
}

/++
 + returns the inverse of the provided matrix, if no inverse can be found it returns a mat4(inf)
 +/
@nogc Mat4 matInverse(const Mat4 a) pure nothrow
{
    Mat4 t = a;

    float det2_01_01 = t[0, 0] * t[1, 1] - t[0, 1] * t[1, 0];
    float det2_01_02 = t[0, 0] * t[1, 2] - t[0, 2] * t[1, 0];
    float det2_01_03 = t[0, 0] * t[1, 3] - t[0, 3] * t[1, 0];
    float det2_01_12 = t[0, 1] * t[1, 2] - t[0, 2] * t[1, 1];
    float det2_01_13 = t[0, 1] * t[1, 3] - t[0, 3] * t[1, 1];
    float det2_01_23 = t[0, 2] * t[1, 3] - t[0, 3] * t[1, 2];

    float det3_201_012 = t[2, 0] * det2_01_12 - t[2, 1] * det2_01_02 + t[2, 2] * det2_01_01;
    float det3_201_013 = t[2, 0] * det2_01_13 - t[2, 1] * det2_01_03 + t[2, 3] * det2_01_01;
    float det3_201_023 = t[2, 0] * det2_01_23 - t[2, 2] * det2_01_03 + t[2, 3] * det2_01_02;
    float det3_201_123 = t[2, 1] * det2_01_23 - t[2, 2] * det2_01_13 + t[2, 3] * det2_01_12;

    float det = - det3_201_123 * t[3, 0] + det3_201_023 * t[3, 1] - det3_201_013 * t[3, 2] + det3_201_012 * t[3, 3];
    float invDet = 1 / det;

    float det2_03_01 = t[0, 0] * t[3, 1] - t[0, 1] * t[3, 0];
    float det2_03_02 = t[0, 0] * t[3, 2] - t[0, 2] * t[3, 0];
    float det2_03_03 = t[0, 0] * t[3, 3] - t[0, 3] * t[3, 0];
    float det2_03_12 = t[0, 1] * t[3, 2] - t[0, 2] * t[3, 1];
    float det2_03_13 = t[0, 1] * t[3, 3] - t[0, 3] * t[3, 1];
    float det2_03_23 = t[0, 2] * t[3, 3] - t[0, 3] * t[3, 2];
    float det2_13_01 = t[1, 0] * t[3, 1] - t[1, 1] * t[3, 0];
    float det2_13_02 = t[1, 0] * t[3, 2] - t[1, 2] * t[3, 0];
    float det2_13_03 = t[1, 0] * t[3, 3] - t[1, 3] * t[3, 0];
    float det2_13_12 = t[1, 1] * t[3, 2] - t[1, 2] * t[3, 1];
    float det2_13_13 = t[1, 1] * t[3, 3] - t[1, 3] * t[3, 1];
    float det2_13_23 = t[1, 2] * t[3, 3] - t[1, 3] * t[3, 2];

    float det3_203_012 = t[2, 0] * det2_03_12 - t[2, 1] * det2_03_02 + t[2, 2] * det2_03_01;
    float det3_203_013 = t[2, 0] * det2_03_13 - t[2, 1] * det2_03_03 + t[2, 3] * det2_03_01;
    float det3_203_023 = t[2, 0] * det2_03_23 - t[2, 2] * det2_03_03 + t[2, 3] * det2_03_02;
    float det3_203_123 = t[2, 1] * det2_03_23 - t[2, 2] * det2_03_13 + t[2, 3] * det2_03_12;

    float det3_213_012 = t[2, 0] * det2_13_12 - t[2, 1] * det2_13_02 + t[2, 2] * det2_13_01;
    float det3_213_013 = t[2, 0] * det2_13_13 - t[2, 1] * det2_13_03 + t[2, 3] * det2_13_01;
    float det3_213_023 = t[2, 0] * det2_13_23 - t[2, 2] * det2_13_03 + t[2, 3] * det2_13_02;
    float det3_213_123 = t[2, 1] * det2_13_23 - t[2, 2] * det2_13_13 + t[2, 3] * det2_13_12;

    float det3_301_012 = t[3, 0] * det2_01_12 - t[3, 1] * det2_01_02 + t[3, 2] * det2_01_01;
    float det3_301_013 = t[3, 0] * det2_01_13 - t[3, 1] * det2_01_03 + t[3, 3] * det2_01_01;
    float det3_301_023 = t[3, 0] * det2_01_23 - t[3, 2] * det2_01_03 + t[3, 3] * det2_01_02;
    float det3_301_123 = t[3, 1] * det2_01_23 - t[3, 2] * det2_01_13 + t[3, 3] * det2_01_12;

    Mat4 res;

    res[0, 0] = - det3_213_123 * invDet;
    res[1, 0] = + det3_213_023 * invDet;
    res[2, 0] = - det3_213_013 * invDet;
    res[3, 0] = + det3_213_012 * invDet;

    res[0, 1] = + det3_203_123 * invDet;
    res[1, 1] = - det3_203_023 * invDet;
    res[2, 1] = + det3_203_013 * invDet;
    res[3, 1] = - det3_203_012 * invDet;

    res[0, 2] = + det3_301_123 * invDet;
    res[1, 2] = - det3_301_023 * invDet;
    res[2, 2] = + det3_301_013 * invDet;
    res[3, 2] = - det3_301_012 * invDet;

    res[0, 3] = - det3_201_123 * invDet;
    res[1, 3] = + det3_201_023 * invDet;
    res[2, 3] = - det3_201_013 * invDet;
    res[3, 3] = + det3_201_012 * invDet;

    return res;
}

unittest
{
    auto t1 = Mat2(2f);
    auto t2 = Mat2(1f, 2f, 3f, 4f);

    assert(t1[0, 0] == 2f);
    assert(t1[0, 1] == 2f);
    assert(t1[1, 0] == 2f);
    assert(t1[1, 1] == 2f);

    assert(t2[0, 0] == 1f);
    assert(t2[0, 1] == 2f);
    assert(t2[1, 0] == 3f);
    assert(t2[1, 1] == 4f);

    t1[0, 0] = 5f;
    assert(t1[0, 0] == 5f);
}

unittest
{
    auto t1 = Mat2(1f, 2f, 3f, 4f);
    assert(t1 * 2f == Mat2(2f, 4f, 6f, 8f));
}

unittest
{
    auto m1 = Mat2(1f, 2f, 3f, 4f);
    auto v1 = Vec2(4f, 6f);
    assert(m1 * v1 == Vec2(16f, 36f));
}

unittest
{
    auto m1 = Mat2(1f, 2f, 3f, 4f);
    auto m2 = Mat2(5f, 6f, 7f, 8f);
    assert(m1 * m2 == Mat2(19f, 22f, 43f, 50f));
    m1 *= m2;
    assert(m1 == Mat2(19f, 22f, 43f, 50f));
}

unittest 
{
    auto m1 = Mat2(1f, 2f, 3f, 4f);
    auto m2 = Mat2(5f, 6f, 7f, 8f);
    assert(m1 + m2 == Mat2(6f, 8f, 10f, 12f));
}

unittest 
{
    auto m1 = Mat2(5f, 6f, 7f, 8f);
    auto m2 = Mat2(1f, 2f, 3f, 4f);
    assert(m1 - m2 == Mat2(4f));
}

unittest
{
    auto m1 = matIdentity!2();
    assert(m1 == Mat2(1f, 0f, 0f, 1f));
}

unittest
{
    auto scaling = matScaling!2(Vec!1(3f));
    assert(scaling == Mat2(3f, 0f, 0f, 1f));

    auto m1 = Mat2(1f, 2f, 3f, 4f);
    assert(m1 * scaling == Mat2(3f, 2f, 9f, 4f));
}

unittest
{
    auto trans = matTranslation!3(Vec2(4f));
    assert(trans == Mat3(1f, 0f, 4f, 0f, 1f, 4f, 0f, 0f, 1f));

    auto m1 = Mat3(3f);
    assert(m1 * trans == Mat3(3f, 3f, 27f, 3f, 3f, 27f, 3f, 3f, 27f));
}

unittest 
{
    auto m1 = Mat4(5f, 6f, 6f, 8f, 2f, 2f, 2f, 8f, 6f, 6f, 2f, 8f, 2f, 3f, 6f, 7f);
    assert(matInverse(m1) * m1 == matIdentity!4());
}
