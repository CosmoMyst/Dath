module cosmomyst.math.vector;

alias vec2 = vec!2;
alias vec3 = vec!3;
alias vec4 = vec!4;

/++
 + vec struct with optional amount of components.
 +/
struct vec(ulong n) if (n >= 1) {
    union {
        /++
         + internal data
         +/
        float[n] v;

        struct {
            static if (n >= 1) {
                float x;
            }

            static if (n >= 2) {
                float y;
            }

            static if (n >= 3) {
                float z;
            }

            static if (n >= 4) {
                float w;
            }
        }
    }

    @nogc this(T...)(T args) pure nothrow {
        import std.traits : isNumeric;

        static foreach (arg; args) {
            static assert(isNumeric!(typeof(arg)), "all values must be numeric");
        }

        static assert(args.length > 0, "no args provided");

        static assert(args.length == 1 || args.length == n, "number of args must be either 1 or number of components");

        static if (args.length == 1) {
            static foreach (i; 0..n) {
                v[i] = args[0];
            }
        } else {
            static foreach (i, arg; args) {
                v[i] = arg;
            }
        }
    }

    /++
     + internal data as a pointer, use for sending data to shaders.
     +/
    @nogc auto ptr() pure nothrow const {
        return v.ptr;
    }

    @nogc float length() pure nothrow const {
        import std.math : sqrt;

        float sum = 0;
        for (int i = 0; i < n; i++) {
            sum += v[i] * v[i];
        }

        return sqrt(sum);
    }

    /++
     + normalizes the vectors. changes the current struct!
     +/
    @nogc void normalize() pure nothrow {
        this = normalized();
    }

    /++
     + returns the normalized vector. doesn't change the current struct!
     +/
    @nogc vec!n normalized() pure nothrow const {
        if (length() == 0) {
            return vec!n(0f);
        }
        return this / length();
    }

    /++
     + returns the negated vector.
     +/
    @nogc vec!n opUnary(string s)() const if (s == "-") {
        vec!n res;
        for (int i = 0; i < n; i++) {
            res.v[i] = -v[i];
        }
        return res;
    }

    /++
     + returns the mul of this * scalar
     +/
    @nogc vec!n opBinary(string s) (const float scalar) const if (s == "*") {
        vec!n res;
        for (int i = 0; i < n; i++) {
            res[i] = this[i] * scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const float scalar) pure nothrow if (s == "*") {
        auto res = this * scalar;
        this.v = res.v;
    }

    /++
     + returns the sum of this + scalar
     +/
    @nogc vec!n opBinary(string s) (const float scalar) const if (s == "+") {
        vec!n res;
        for (int i = 0; i < n; i++) {
            res[i] = this[i] + scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const float scalar) const if (s == "+") {
        auto res = this + scalar;
        this.v = res.v;
    }

    /++
     + returns the sub of this - scalar
     +/
    @nogc vec!n opBinary(string s) (const float scalar) const if (s == "-") {
        vec!n res;
        for (int i = 0; i < n; i++) {
            res[i] = this[i] - scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const float scalar) const if (s == "-") {
        auto res = this - scalar;
        this.v = res.v;
    }

    /++
     + returns the div of this / scalar.
     +/
    @nogc vec!n opBinary(string s) (in float scalar) const if (s == "/") {
        vec!n res;
        for (int i = 0; i < n; i++) {
            res.v[i] = v[i] / scalar;
        }
        return res;
    }

    @nogc void opOpAssign(string s) (in float scalar) const if (s == "/") {
        auto res = this / scalar;
        this.v = res.v;
    }

    /++
     + returns the sum of 2 vectors
     +/
    @nogc vec!n opBinary(string s) (const vec!n other) const if (s == "+") {
        vec!n res;
        for (int i = 0; i < n; i++) {
            res.v[i] = v[i] + other.v[i];
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const vec!n other) const if (s == "+") {
        auto res = this + other;
        this.v = res.v;
    }

    /++
     + returns the sub of 2 vectors.
     +/
    @nogc vec!n opBinary(string s) (const vec!n other) const if (s == "-") {
        vec!n res;
        for (int i = 0; i < n; i++) {
            res.v[i] = v[i] - other.v[i];
        }
        return res;
    }

    @nogc void opOpAssign(string s) (const vec!n other) const if (s == "-") {
        auto res = this - other;
        this.v = res.v;
    }

    /++
     + get the nth component
     +/
    @nogc float opIndex(int n) pure const nothrow {
        return v[n];
    }

    /++
     + set the nth component
     +/
    @nogc float opIndexAssign(float value, int n) pure nothrow {
        return v[n] = value;
    }
}

/++
 + returns the dot product of 2 vectors.
 +/
@nogc float vec_dot(ulong n)(vec!n a, vec!n b) pure nothrow {
    float res = 0f;
    static foreach (i; 0..n) {
        res += a.v[i] * b.v[i];
    }
    return res;
}

/++
 + returns the cross product of 2 vectors.
 +/
@nogc vec!3 vec_cross(vec!3 a, vec!3 b) pure nothrow {
    return vec!3(a.y * b.z - a.z * b.y,
                 a.z * b.x - a.x * b.z,
                 a.x * b.y - a.y * b.x);
}

unittest {
    auto t1 = vec2(2f, 3f);

    assert(t1.x == 2f);
    assert(t1.y == 3f);

    auto t2 = vec2(2f);
    assert(t2.x == 2f);
    assert(t2.y == 2f);
}

unittest {
    auto t1 = vec2(2, 3);

    assert(t1 * 2 == vec2(4, 6));
}

unittest {
    auto t1 = vec3(5f, 2f, 6f);
    assert(t1.length() == 8.06225774829855f);
}

unittest {
    auto t1 = vec3(2f, 5f, 3f);
    auto t2 = vec3(7f, 4f, 9f);
    assert(vec_dot!3(t1, t2) == 61);
}

unittest {
    auto t1 = vec3(2f, 3f, 4f);
    auto t2 = vec3(5f, 6f, 7f);
    assert(vec_cross(t1, t2) == vec3(-3f, 6f, -3f));
}

unittest {
    auto t1 = vec3(5f, 2f, 7f);
    assert(-t1 == vec3(-5f, -2f, -7f));
}

unittest {
    auto t1 = vec3(5f, 2f, 7f);
    auto t2 = vec3(3f, 7f, 2f);
    assert(t1 - t2 == vec3(2f, -5f, 5f));
}

unittest {
    auto t1 = vec3(1f, 2f, 3f);
    assert(t1 * 2 == vec3(2f, 4f, 6f));
}
