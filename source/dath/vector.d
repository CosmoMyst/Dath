module dath.vector;

version(unittest) import fluent.asserts;

import std.traits;

alias Vec2f = Vec!(float, 2);
alias Vec3f = Vec!(float, 3);
alias Vec4f = Vec!(float, 4);

alias Vec2 = Vec2f;
alias Vec3 = Vec3f;
alias Vec4 = Vec4f;

alias Vec2d = Vec!(double, 2);
alias Vec3d = Vec!(double, 3);
alias Vec4d = Vec!(double, 4);

alias Vec2i = Vec!(int, 2);
alias Vec3i = Vec!(int, 3);
alias Vec4i = Vec!(int, 4);

alias Vec2u = Vec!(uint, 2);
alias Vec3u = Vec!(uint, 3);
alias Vec4u = Vec!(uint, 4);

/++
 + Numeric Vector type with an optional amount of components.
 +/
public struct Vec(T, ulong n) if (n >= 1 && isNumeric!T)
{
    union {
        /++
         + Internal data.
         +/
        T[n] v;

        struct
        {
            // Predefined component names.

            static if (n >= 1)
            {
                T x;
            }

            static if (n >= 2)
            {
                T y;
            }

            static if (n >= 3)
            {
                T z;
            }

            static if (n >= 4)
            {
                T w;
            }
        }
    }

    private alias _t = T;
    private enum _n = n;

    public this(U)(U[] elements) @nogc pure nothrow
    {
        assert(isNumeric!U, "All components must be numeric.");

        assert(elements.length > 0, "No components provided.");

        assert(elements.length == 1 || elements.length == n,
            "Number of components must be either 1 or the number of components the vector holds.");
        
        v = elements;
    }

    public this(U...)(U args) @nogc pure nothrow
    {
        static foreach (arg; args)
        {
            static assert(isNumeric!(typeof(arg)), "All components must be numeric");
        }

        static assert(args.length > 0, "No components provided.");

        static assert(args.length == 1 || args.length == n,
            "Number of components must be either 1 or the number of components the vector holds.");

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
     + Internal data as a pointer, use for sending data to shaders.
     +/
    public auto ptr() @nogc pure nothrow const
    {
        return v.ptr;
    }

    /++ 
     + Vector magnitude.
     +/
    public real magnitude() @nogc pure nothrow const
    {
        import std.math : sqrt;

        real sum = 0;
        for (int i = 0; i < n; i++)
        {
            sum += v[i] * v[i];
        }

        return sqrt(sum);
    }

    /++
     + Normalizes the vectors. Changes the current struct!
     +/
    public void normalize() @nogc pure nothrow
    {
        this = normalized();
    }

    /++
     + Returns the normalized vector. Doesn't change the current struct!
     +/
    public Vec!(T, n) normalized() @nogc pure nothrow const
    {
        real mag = magnitude();

        if (mag == 0)
        {
            return Vec!(T, n)(0);
        }

        return this / mag;
    }

    /++
     + Returns the negated vector.
     +/
    public Vec!(T, n) opUnary(string s)() @nogc pure nothrow const if (s == "-")
    {
        Vec!(T, n) res;
        res.v = -v[];
        return res;
    }

    /++
     + Returns the mul of this * scalar.
     +/
    public Vec!(T, n) opBinary(string s) (const float scalar) @nogc pure nothrow const if (s == "*")
    {
        Vec!(T, n) res;
        res.v = v[] * scalar;
        return res;
    }

    /++
     + Returns the mul of this * scalar.
     +/
    public void opOpAssign(string s) (const float scalar) @nogc pure nothrow if (s == "*")
    {
        v[] *= scalar;
    }

    /++
     + Returns the sum of this + scalar.
     +/
    public Vec!(T, n) opBinary(string s) (const float scalar) @nogc pure nothrow const if (s == "+")
    {
        Vec!(T, n) res;
        res.v = v[] + scalar;
        return res;
    }

    /++
     + Returns the sum of this + scalar.
     +/
    public void opOpAssign(string s) (const float scalar) @nogc pure nothrow if (s == "+")
    {
        v[] += scalar;
    }

    /++
     + Returns the sub of this - scalar.
     +/
    public Vec!(T, n) opBinary(string s) (const float scalar) @nogc pure nothrow const if (s == "-")
    {
        Vec!(T, n) res;
        res.v = v[] - scalar;
        return res;
    }

    /++
     + Returns the sub of this - scalar.
     +/
    public void opOpAssign(string s) (const float scalar) @nogc pure nothrow if (s == "-")
    {
        v[] -= scalar;
    }

    /++
     + Returns the div of this / scalar.
     +/
    public Vec!(T, n) opBinary(string s) (in float scalar) @nogc pure nothrow const if (s == "/")
    {
        Vec!(T, n) res;
        res.v = v[] / cast(T) scalar;
        return res;
    }

    /++
     + Returns the div of this / scalar.
     +/
    public void opOpAssign(string s) (in float scalar) @nogc pure nothrow if (s == "/")
    {
        v[] /= scalar;
    }

    /++
     + Returns the sum of 2 vectors.
     +/
    public Vec!(T, n) opBinary(string s) (const Vec!(T, n) other) @nogc pure nothrow const if (s == "+")
    {
        Vec!(T, n) res;
        res.v = v[] + other.v[];
        return res;
    }

    /++
     + Returns the sum of 2 vectors.
     +/
    public void opOpAssign(string s) (const Vec!(T, n) other) @nogc pure nothrow if (s == "+")
    {
        v[] += other.v[];
    }

    /++
     + Returns the sub of 2 vectors.
     +/
    public Vec!(T, n) opBinary(string s) (const Vec!(T, n) other) @nogc pure nothrow const if (s == "-")
    {
        Vec!(T, n) res;
        res.v = v[] - other.v[];
        return res;
    }

    /++
     + Returns the sub of 2 vectors.
     +/
    public void opOpAssign(string s) (const Vec!(T, n) other) @nogc pure nothrow if (s == "-")
    {
        v[] -= other.v[];
    }

    /++
     + Returns the mul of 2 vectors.
     +/
    public Vec!(T, n) opBinary(string s) (const Vec!(T, n) other) @nogc pure nothrow const if (s == "*")
    {
        Vec!(T, n) res;
        res.v = v[] * other.v[];
        return res;
    }

    /++
     + Returns the mul of 2 vectors.
     +/
    public void opOpAssign(string s) (const Vec!(T, n) other) @nogc pure nothrow if (s == "*")
    {
        v[] *= other.v[];
    }

    /++
     + Returns the div of 2 vectors.
     +/
    public Vec!(T, n) opBinary(string s) (const Vec!(T, n) other) @nogc pure nothrow const if (s == "/")
    {
        Vec!(T, n) res;
        res.v = v[] / other.v[];
        return res;
    }

    /++
     + Returns the div of 2 vectors.
     +/
    public void opOpAssign(string s) (const Vec!(T, n) other) @nogc pure nothrow if (s == "/")
    {
        v[] /= other.v[];
    }

    /++
     + Get the N-th component.
     +/
    public T opIndex(int n) @nogc pure const nothrow
    {
        return v[n];
    }

    /++
     + Get the whole internal array.
     +/
    public T[n] opIndex() @nogc pure const nothrow
    {
        return v[];
    }

    /++
     + Set the nth component
     +/
    public T opIndexAssign(T value, int n) @nogc pure nothrow
    {
        return v[n] = value;
    }

    /++
     + Cast to a vector of a different type.
     +/
    public U opCast(U)() pure nothrow const if (is(U : Vec!R, R...) && (U._n == n))
    {
        U res;
        foreach (i, el; v)
        {
            res.v[i] = cast(U._t) v[i];
        }
        return res;
    }

    /++ 
     + Swizzling.
     +/
    public Vec!(T, swizzle.length) opDispatch(const string swizzle)() @nogc const pure nothrow
    {
        T[swizzle.length] arr;

        static foreach (i, c; swizzle)
        {
            static assert(coordToIdx!(c) <= n-1, "Trying to swizzle the " ~ c ~ " component, but this vector is too small.");

            arr[i] = v[coordToIdx!(c)];
        }

        Vec!(T, swizzle.length) res;
        res.v = arr;
        return res;
    }

    private template coordToIdx(char c)
    {
        static if (c == 'x') enum coordToIdx = 0;
        else static if (c == 'y') enum coordToIdx = 1;
        else static if (c == 'z') enum coordToIdx = 2;
        else static if (c == 'w') enum coordToIdx = 3;
        else static assert(false, "Unknown vector component " ~ c);
    }
}

/++
 + Returns the dot product of 2 vectors.
 +/
public real dot(T, ulong n)(Vec!(T, n) a, Vec!(T, n) b) @nogc pure nothrow
{
    real res = 0f;
    static foreach (i; 0..n)
    {
        res += a.v[i] * b.v[i];
    }
    return res;
}

/++
 + Returns the cross product of 2 Vec3. The result is always a float Vec3.
 +/
public Vec!(float, 3) cross(T)(Vec!(T, 3) a, Vec!(T, 3) b) @nogc pure nothrow
{
    return Vec!(float, 3)(a.y * b.z - a.z * b.y,
                          a.z * b.x - a.x * b.z,
                          a.x * b.y - a.y * b.x);
}

@("Creating vectors")
unittest
{
    const t1 = Vec2(2f, 3f);

    t1.x.should.equal(2f);
    t1.y.should.equal(3f);

    const t2 = Vec2(2f);

    t2.x.should.equal(2f);
    t2.y.should.equal(2f);

    const t3 = Vec4d(1f, 2f, 3f, 4f);

    t3.x.should.equal(1f);
    t3.y.should.equal(2f);
    t3.z.should.equal(3f);
    t3.w.should.equal(4f);

    const t4 = Vec2i(5, 6);

    t4.x.should.equal(5);
    t4.y.should.equal(6);

    const float[] arr = [1f, 2f];
    const t5 = Vec2(arr);

    t5.x.should.equal(1);
    t5.y.should.equal(2);
}

@("Vector magnitude")
unittest
{
    const t1 = Vec3(5, 6, 8);

    t1.magnitude().should.be.approximately(11.180, 0.01);

    const t2 = Vec2d(65, 76);

    t2.magnitude().should.be.approximately(100, 0.01);
}

@("Vector normalization")
unittest
{
    const t1 = Vec3(75, 64, 23);
    const t2 = t1.normalized();

    t2.x.should.be.approximately(0.74, 0.01);
    t2.y.should.be.approximately(0.63, 0.01);
    t2.z.should.be.approximately(0.22, 0.01);
}

@("Vector scalar operations")
unittest
{
    auto t1 = Vec3(63, 75, 38);

    // negation
    (-t1).should.equal(Vec3(-63, -75, -38));

    // multiplication with a scalar
    (t1 * 2).should.equal(Vec3(126, 150, 76));
    t1 *= 3;
    t1.should.equal(Vec3(189, 225, 114));

    // sum with a scalar
    (t1 + 2).should.equal(Vec3(191, 227, 116));
    t1 += 3;
    t1.should.equal(Vec3(192, 228, 117));

    // sub with a scalar
    (t1 - 2).should.equal(Vec3(190, 226, 115));
    t1 -= 3;
    t1.should.equal(Vec3(189, 225, 114));

    // division with a scalar
    (t1 / 2).should.equal(Vec3(94.5, 112.5, 57));
    t1 /= 3;
    t1.should.equal(Vec3(63, 75, 38));
}

@("Vector operations with other vectors")
unittest
{
    auto t1 = Vec3(63, 75, 38);
    auto t2 = Vec3(37, 98, 100);

    // sum of 2 vectors
    (t1 + t2).should.equal(Vec3(100, 173, 138));
    t1 += t2;
    t1.should.equal(Vec3(100, 173, 138));

    // sub of 2 vectors
    (t1 - t2).should.equal(Vec3(63, 75, 38));
    t1 -= t2;
    t1.should.equal(Vec3(63, 75, 38));

    // multiplication of 2 vectors
    (t1 * t2).should.equal(Vec3(2331, 7350, 3800));
    t1 *= t2;
    t1.should.equal(Vec3(2331, 7350, 3800));

    // division of 2 vectors
    (t1 / t2).should.equal(Vec3(63, 75, 38));
    t1 /= t2;
    t1.should.equal(Vec3(63, 75, 38));
}

@("Vector components and casting")
unittest
{
    auto t1 = Vec3(63, 75, 38);

    t1[0].should.equal(63);

    t1[1] = 100;
    t1[1].should.equal(100);
    t1.y.should.equal(100);

    auto t2 = cast(Vec3d) t1;
    t2.should.equal(Vec3d(63, 100, 38));

    auto t3 = cast(Vec3i) t2;
    t3.should.equal(Vec3i(63, 100, 38));
}

@("Vector dot and cross product")
unittest
{
    const t1 = Vec3(63, 75, 38);
    const t2 = Vec3(37, 98, 100);

    t1.dot(t2).should.equal(13_481);

    t1.cross(t2).should.equal(Vec3(3776, -4894, 3399));
}

@("Vector swizzling")
unittest
{
    const t1 = Vec3(4, 5, 6);
    const t2 = t1.xz;

    t2.should.equal(Vec2(4, 6));

    const t3 = Vec4(1f, 2f, 3f, 4f);
    const t4 = t3.xxyyww;

    t4.should.equal(Vec!(float, 6)(1f, 1f, 2f, 2f, 4f, 4f));
}
