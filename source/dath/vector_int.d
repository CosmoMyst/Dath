module dath.vector_int;

alias VecI2 = VecI!2;
alias VecI3 = VecI!3;
alias VecI4 = VecI!4;

/++
 + vec struct with optional amount of components.
 +/
struct VecI(ulong n) if (n >= 1)
{
    union {
        /++
         + internal data
         +/
        int[n] v;

        struct
        {
            static if (n >= 1)
            {
                int x;
            }

            static if (n >= 2)
            {
                int y;
            }

            static if (n >= 3)
            {
                int z;
            }

            static if (n >= 4)
            {
                int w;
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
     + returns the negated vector.
     +/
    @nogc VecI!n opUnary(string s)() const if (s == "-")
    {
        VecI!n res;
        for (int i = 0; i < n; i++)
        {
            res.v[i] = -v[i];
        }
        return res;
    }

    /++
     + returns the mul of this * scalar
     +/
    @nogc VecI!n opBinary(string s) (const int scalar) const if (s == "*")
    {
        VecI!n res;
        for (int i = 0; i < n; i++)
        {
            res[i] = this[i] * scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const int scalar) pure nothrow if (s == "*")
    {
        auto res = this * scalar;
        this.v = res.v;
    }

    /++
     + returns the sum of this + scalar
     +/
    @nogc VecI!n opBinary(string s) (const int scalar) const if (s == "+")
    {
        VecI!n res;
        for (int i = 0; i < n; i++)
        {
            res[i] = this[i] + scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const int scalar) const if (s == "+")
    {
        auto res = this + scalar;
        this.v = res.v;
    }

    /++
     + returns the sub of this - scalar
     +/
    @nogc VecI!n opBinary(string s) (const int scalar) const if (s == "-")
    {
        VecI!n res;
        for (int i = 0; i < n; i++)
        {
            res[i] = this[i] - scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const int scalar) const if (s == "-")
    {
        auto res = this - scalar;
        this.v = res.v;
    }

    /++
     + returns the div of this / scalar.
     +/
    @nogc VecI!n opBinary(string s) (in int scalar) const if (s == "/")
    {
        VecI!n res;
        for (int i = 0; i < n; i++)
        {
            res.v[i] = v[i] / scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (in int scalar) const if (s == "/")
    {
        auto res = this / scalar;
        this.v = res.v;
    }

    /++
     + returns the sum of 2 vectors
     +/
    @nogc VecI!n opBinary(string s) (const VecI!n other) const if (s == "+")
    {
        VecI!n res;
        for (int i = 0; i < n; i++) {
            res.v[i] = v[i] + other.v[i];
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const VecI!n other) const if (s == "+")
    {
        auto res = this + other;
        this.v = res.v;
    }

    /++
     + returns the sub of 2 vectors.
     +/
    @nogc VecI!n opBinary(string s) (const VecI!n other) const if (s == "-")
    {
        VecI!n res;
        for (int i = 0; i < n; i++)
        {
            res.v[i] = v[i] - other.v[i];
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const VecI!n other) const if (s == "-")
    {
        auto res = this - other;
        this.v = res.v;
    }

    /++
     + get the nth component
     +/
    @nogc int opIndex(int n) pure const nothrow
    {
        return v[n];
    }

    /++
     + set the nth component
     +/
    @nogc int opIndexAssign(int value, int n) pure nothrow
    {
        return v[n] = value;
    }
}

unittest
{
    auto t1 = VecI2(2, 3);

    assert(t1.x == 2);
    assert(t1.y == 3);

    auto t2 = VecI2(2);
    assert(t2.x == 2);
    assert(t2.y == 2);
}

unittest
{
    auto t1 = VecI2(2, 3);

    assert(t1 * 2 == VecI2(4, 6));
}

unittest
{
    auto t1 = VecI3(5, 2, 6);
    assert(t1.length() == 8.06225774829855f);
}

unittest
{
    auto t1 = VecI3(5, 2, 7);
    assert(-t1 == VecI3(-5, -2, -7));
}

unittest
{
    auto t1 = VecI3(5, 2, 7);
    auto t2 = VecI3(3, 7, 2);
    assert(t1 - t2 == VecI3(2, -5, 5));
}

unittest
{
    auto t1 = VecI3(1, 2, 3);
    assert(t1 * 2 == VecI3(2, 4, 6));
}
