module dath.vector;

import dath.vector_int;

alias Vec2 = Vec!2;
alias Vec3 = Vec!3;
alias Vec4 = Vec!4;

/++
 + vec struct with optional amount of components.
 +/
struct Vec(ulong n) if (n >= 1)
{
    union {
        /++
         + internal data
         +/
        float[n] v;

        struct
        {
            static if (n >= 1)
            {
                float x;
            }

            static if (n >= 2)
            {
                float y;
            }

            static if (n >= 3)
            {
                float z;
            }

            static if (n >= 4)
            {
                float w;
            }
        }
    }

    @nogc this(T...)(T args) pure nothrow
    {
        import std.traits : isNumeric;

        static foreach (arg; args)
        {
            static assert(isNumeric!(typeof(arg)), "all values must be numeric");
        }

        static assert(args.length > 0, "no args provided");

        static assert(args.length == 1 || args.length == n, "number of args must be either 1 or number of components");

        static if (args.length == 1)
        {
            static foreach (i; 0..n)
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
     + internal data as a pointer, use for sending data to shaders.
     +/
    @nogc auto ptr() pure nothrow const
    {
        return v.ptr;
    }

    @nogc float length() pure nothrow const
    {
        import std.math : sqrt;

        float sum = 0;
        for (int i = 0; i < n; i++)
        {
            sum += v[i] * v[i];
        }

        return sqrt(sum);
    }

    /++
     + normalizes the vectors. changes the current struct!
     +/
    @nogc void normalize() pure nothrow
    {
        this = normalized();
    }

    /++
     + returns the normalized vector. doesn't change the current struct!
     +/
    @nogc Vec!n normalized() pure nothrow const
    {
        if (length() == 0)
        {
            return Vec!n(0f);
        }
        return this / length();
    }

    /++
     + returns the negated vector.
     +/
    @nogc Vec!n opUnary(string s)() const if (s == "-")
    {
        Vec!n res;
        for (int i = 0; i < n; i++)
        {
            res.v[i] = -v[i];
        }
        return res;
    }

    /++
     + returns the mul of this * scalar
     +/
    @nogc Vec!n opBinary(string s) (const float scalar) const if (s == "*")
    {
        Vec!n res;
        for (int i = 0; i < n; i++)
        {
            res[i] = this[i] * scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const float scalar) pure nothrow if (s == "*")
    {
        auto res = this * scalar;
        this.v = res.v;
    }

    /++
     + returns the sum of this + scalar
     +/
    @nogc Vec!n opBinary(string s) (const float scalar) const if (s == "+")
    {
        Vec!n res;
        for (int i = 0; i < n; i++)
        {
            res[i] = this[i] + scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const float scalar) const if (s == "+")
    {
        auto res = this + scalar;
        this.v = res.v;
    }

    /++
     + returns the sub of this - scalar
     +/
    @nogc Vec!n opBinary(string s) (const float scalar) const if (s == "-")
    {
        Vec!n res;
        for (int i = 0; i < n; i++)
        {
            res[i] = this[i] - scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const float scalar) const if (s == "-")
    {
        auto res = this - scalar;
        this.v = res.v;
    }

    /++
     + returns the div of this / scalar.
     +/
    @nogc Vec!n opBinary(string s) (in float scalar) const if (s == "/")
    {
        Vec!n res;
        for (int i = 0; i < n; i++)
        {
            res.v[i] = v[i] / scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (in float scalar) const if (s == "/")
    {
        auto res = this / scalar;
        this.v = res.v;
    }

    /++
     + returns the sum of 2 vectors
     +/
    @nogc Vec!n opBinary(string s) (const Vec!n other) const if (s == "+")
    {
        Vec!n res;
        for (int i = 0; i < n; i++) {
            res.v[i] = v[i] + other.v[i];
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const Vec!n other) const if (s == "+")
    {
        auto res = this + other;
        this.v = res.v;
    }

    /++
     + returns the sub of 2 vectors.
     +/
    @nogc Vec!n opBinary(string s) (const Vec!n other) const if (s == "-")
    {
        Vec!n res;
        for (int i = 0; i < n; i++)
        {
            res.v[i] = v[i] - other.v[i];
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const Vec!n other) const if (s == "-")
    {
        auto res = this - other;
        this.v = res.v;
    }

    /++
     + get the nth component
     +/
    @nogc float opIndex(int n) pure const nothrow
    {
        return v[n];
    }

    /++
     + set the nth component
     +/
    @nogc float opIndexAssign(float value, int n) pure nothrow
    {
        return v[n] = value;
    }

    /++
     + cast to an int vector
     +/
    @nogc VecI!n opCast(T)() pure const nothrow if (is(T == VecI!n))
    {
        VecI!n res;
        for (int i = 0; i < n; i++)
        {
            res.v[i] = cast(int) v[i];
        }
        return res;
    }
}

/++
 + returns the dot product of 2 vectors.
 +/
@nogc float vecDot(ulong n)(Vec!n a, Vec!n b) pure nothrow
{
    float res = 0f;
    static foreach (i; 0..n)
    {
        res += a.v[i] * b.v[i];
    }
    return res;
}

/++
 + returns the cross product of 2 vectors.
 +/
@nogc Vec!3 vecCross(Vec!3 a, Vec!3 b) pure nothrow
{
    return Vec!3(a.y * b.z - a.z * b.y,
                 a.z * b.x - a.x * b.z,
                 a.x * b.y - a.y * b.x);
}

unittest
{
    auto t1 = Vec2(2f, 3f);

    assert(t1.x == 2f);
    assert(t1.y == 3f);

    auto t2 = Vec2(2f);
    assert(t2.x == 2f);
    assert(t2.y == 2f);
}

unittest
{
    auto t1 = Vec2(2, 3);

    assert(t1 * 2 == Vec2(4, 6));
}

unittest
{
    auto t1 = Vec3(5f, 2f, 6f);
    assert(t1.length() == 8.06225774829855f);
}

unittest
{
    auto t1 = Vec3(2f, 5f, 3f);
    auto t2 = Vec3(7f, 4f, 9f);
    assert(vecDot!3(t1, t2) == 61);
}

unittest
{
    auto t1 = Vec3(2f, 3f, 4f);
    auto t2 = Vec3(5f, 6f, 7f);
    assert(vecCross(t1, t2) == Vec3(-3f, 6f, -3f));
}

unittest
{
    auto t1 = Vec3(5f, 2f, 7f);
    assert(-t1 == Vec3(-5f, -2f, -7f));
}

unittest
{
    auto t1 = Vec3(5f, 2f, 7f);
    auto t2 = Vec3(3f, 7f, 2f);
    assert(t1 - t2 == Vec3(2f, -5f, 5f));
}

unittest
{
    auto t1 = Vec3(1f, 2f, 3f);
    assert(t1 * 2 == Vec3(2f, 4f, 6f));
}

unittest
{
    auto t1 = Vec2(1f, 2f);
    auto t2 = cast(VecI2) t1;
    assert(t2.x == 1 && t2.y == 2);
}
