module dath.matrix;

version(unittest) import fluent.asserts;

import std.traits;
import dath.core;
import dath.vector;

alias Mat2f = Mat!(float, 2);
alias Mat3f = Mat!(float, 3);
alias Mat4f = Mat!(float, 4);

alias Mat2 = Mat2f;
alias Mat3 = Mat3f;
alias Mat4 = Mat4f;

alias Mat2d = Mat!(double, 2);
alias Mat3d = Mat!(double, 3);
alias Mat4d = Mat!(double, 4);

alias Mat2i = Mat!(int, 2);
alias Mat3i = Mat!(int, 3);
alias Mat4i = Mat!(int, 4);

alias Mat2u = Mat!(uint, 2);
alias Mat3u = Mat!(uint, 3);
alias Mat4u = Mat!(uint, 4);

/++
 + A square NxN matrix. Supports any numeric type.
 +/
struct Mat(T, ulong n) if (n >= 2 && isNumeric!T)
{
    union
    {
        T[n*n] v; // all values
        T[n][n] c; // all components
    }

    public this(T...)(T args) @nogc pure nothrow
    {
        static foreach (arg; args)
        {
            static assert(isNumeric!(typeof(arg)), "All values must be numeric.");
        }

        static assert(args.length > 0, "No args provided.");

        static assert(args.length == 1 || args.length == n*n, "Number of args must be either 1 or N*N.");

        static if (args.length == 1)
        {
            v[] = args[0];
        }
        else
        {
            v = [args];
        }
    }

    /++
     + Get the value at [i, j]
     +/
    public T opIndex(int i, int j) @nogc pure const nothrow
    {
        return c[i][j];
    }

    /++
     + Set the value at [i, j]
     +/
    public T opIndexAssign(T value, int i, int j) @nogc pure nothrow
    {
        return c[i][j] = value;
    }

    /++
     + Returns this matrix * scalar
     +/
    public auto opBinary(string s) (const float scalar) @nogc pure const nothrow if (s == "*")
    {
        Mat!(T, n) res;
        res.v = v[] * scalar;
        return res;
    }

    /++
     + Returns this matrix * scalar
     +/
    public void opOpAssign(string s) (const float scalar) @nogc pure nothrow if (s == "*")
    {
        v[] *= scalar;
    }

    /++
     + Returns this matrix * vector
     +/
    public auto opBinary(string s) (const Vec!(T, n) vector) @nogc pure const nothrow if (s == "*")
    {
        Vec!(T, n) res;

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
     + Returns this matrix * matrix
     +/
    public auto opBinary(string s) (const Mat!(T, n) other) @nogc pure const nothrow if (s == "*")
    {
        Mat!(T, n) res;

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
     + Returns this matrix * matrix
     +/
    public void opOpAssign (string s) (const Mat!(T, n) other) @nogc pure nothrow if (s == "*")
    {
        auto res = this * other;
        this.v = res.v;
    }

    /++
     + Returns sum or sub of two matrices
     +/
     public auto opBinary(string s) (const Mat!(T, n) other) @nogc pure const nothrow if (s == "+" || s == "-")
     {
        Mat!(T, n) res;

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
     + Internal data as a pointer, use for sending data to shaders.
     +/
    public auto ptr() @nogc pure const nothrow
    {
        return v.ptr;
    }
}

/++
 + creates an identity matrix
 +/
public Mat!(T, n) identity(T, ulong n)() @nogc pure nothrow
{
    Mat!(T, n) res;
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            res[i, j] = i == j ? 1 : 0;
        }
    }
    return res;
}

/++
 + Creates a scaling matrix
 +/
public Mat!(T, n) scaling(T, ulong n)(Vec!(T, n-1) v) @nogc pure nothrow
{
    auto res = identity!(T, n);
    for (int i = 0; i + 1 < n; i++)
    {
        res[i, i] = v[i];
    }
    return res;
}

/++
 + Creates a rotation matrix, angle in radians
 +/
public auto rotation(T)(float angle, Vec!(T, 3) axis) @nogc pure nothrow
{
    import std.math : sin, cos;

    auto res = identity!(T, 4)();
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
 + Creates a translation matrix
 +/
public auto translation(T, ulong n)(Vec!(T, n-1) v) @nogc pure nothrow
{
    auto res = identity!(T, n)();
    for (int i = 0; i + 1 < n; i++)
    {
        res[i, n-1] = res[i, n-1] + v[i];
    }
    return res;
}

/++
 + Creates a look-at matrix
 +/
public auto lookAt(Vec3 eye, Vec3 target, Vec3 up) @nogc pure nothrow
{
    Vec3 z = (eye - target).normalized();
    Vec3 x = cross(-up, z).normalized();
    Vec3 y = cross(z, -x);

    return Mat4(-x.x, -x.y, -x.z,  dot(x, eye),
                 y.x,  y.y,  y.z, -dot(y, eye),
                 z.x,  z.y,  z.z, -dot(z, eye),
                 0,    0,    0,    1);
}

/++
 + Creates an orthographic projection matrix
 +/
public auto orthographic(float left, float right, float bottom, float top, float near, float far) @nogc pure nothrow
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
 + Creates a perspective projection matrix
 +/
public auto perspective(float fov_in_radians, float aspect, float near, float far) @nogc pure nothrow
{
    import core.stdc.math : tan;

    float f = 1 / tan(fov_in_radians / 2);
    float d = 1 / (near - far);

    return Mat4(f / aspect, 0f, 0f,               0f,
                0f,         f,  0f,               0f,
                0f,         0f, (far + near) * d, 2 * d * far * near,
                0f,         0f, -1f,              0f);
}

/++
 + Returns the inverse of the provided matrix, if no inverse can be found it returns a `Mat4(inf)`
 +/
public Mat4 inverse(const Mat4 a) @nogc pure nothrow
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

@("Creating matrices")
unittest
{
    auto t1 = Mat2(2f);
    const t2 = Mat2(1f, 2f, 3f, 4f);

    t1[0, 0].should.equal(2f);
    t1[0, 1].should.equal(2f);
    t1[1, 0].should.equal(2f);
    t1[1, 1].should.equal(2f);

    t2[0, 0].should.equal(1f);
    t2[0, 1].should.equal(2f);
    t2[1, 0].should.equal(3f);
    t2[1, 1].should.equal(4f);

    t1[0, 0] = 5f;
    t1[0, 0].should.equal(5f);
}

@("Matrix multiplication by scalar")
unittest
{
    const t1 = Mat2(1f, 2f, 3f, 4f);
    (t1 * 2f).should.equal(Mat2(2, 4, 6, 8));
}

@("Matrix multiplication by vector")
unittest
{
    const m1 = Mat2(1f, 2f, 3f, 4f);
    const v1 = Vec2(4f, 6f);
    (m1 * v1).should.equal(Vec2(16f, 36f));
}

@("Matrix multiplication by matrix")
unittest
{
    auto m1 = Mat2(1f, 2f, 3f, 4f);
    const m2 = Mat2(5f, 6f, 7f, 8f);
    (m1 * m2).should.equal(Mat2(19, 22, 43, 50));
    m1 *= m2;
    m1.should.equal(Mat2(19, 22, 43, 50));
}

@("Adding 2 matrices")
unittest 
{
    const m1 = Mat2(1f, 2f, 3f, 4f);
    const m2 = Mat2(5f, 6f, 7f, 8f);
    (m1 + m2).should.equal(Mat2(6, 8, 10, 12));
}

@("Subtracting 2 matrices")
unittest 
{
    const m1 = Mat2(5f, 6f, 7f, 8f);
    const m2 = Mat2(1f, 2f, 3f, 4f);
    (m1 - m2).should.equal(Mat2(4));
}

@("Identity matrix")
unittest
{
    const m1 = identity!(float, 2)();
    m1.should.equal(Mat2(1, 0, 0, 1));
}

@("Scaling matrix")
unittest
{
    const scaling = scaling!(float, 2)(Vec!(float, 1)(3f));
    scaling.should.equal(Mat2(3, 0, 0, 1));

    const m1 = Mat2(1f, 2f, 3f, 4f);
    (m1 * scaling).should.equal(Mat2(3, 2, 9, 4));
}

@("Translation matrix")
unittest
{
    const trans = translation!(float, 3)(Vec2(4f));
    trans.should.equal(Mat3(1, 0, 4, 0, 1, 4, 0, 0, 1));

    const m1 = Mat3(3f);
    (m1 * trans).should.equal(Mat3(3, 3, 27, 3, 3, 27, 3, 3, 27));
}

@("Matrix inverse")
unittest 
{
    const m1 = Mat4(5f, 6f, 6f, 8f, 2f, 2f, 2f, 8f, 6f, 6f, 2f, 8f, 2f, 3f, 6f, 7f);
    (inverse(m1) * m1).should.equal(identity!(float, 4));
}
