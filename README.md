# Dath

[![DUB](https://img.shields.io/dub/v/dath)](https://code.dlang.org/packages/dath)

A simple math library intended for games, written in D.

The reason for making this library is for personal projects, learning, and it simply being fun to make. As such, this library is a work in progress, the API might change, and the implementation of math functions is definitely a naive one, and performance isn't a huge factor as it's intended for small 2D games, though I will still try and improve performance when I can.

Inspiration and ideas from: [gfm](https://code.dlang.org/packages/gfm) and [gl3n](https://github.com/Dav1dde/gl3n).

All functions are `nogc`.

## Usage

Add to your project: `dub add dath`.

Import: `import dath;`.

## Documentation

As the library is pretty small, all the documentation will be provided in this README file. You can also look in the unittests of each module for usage.

### `dath.core`

Some basic math functions.

---

```d
const double PI = 3.14159265358979323846;
```

---

Convert degrees to radians.

```d
float rad(float deg) @nogc pure nothrow;
```

---

Convert radians to degrees.

```d
float deg(float rad) @nogc pure nothrow;
```

### `dath.rect`

```d
alias Rectf = Rect!float;
alias Rectd = Rect!double;
alias Recti = Rect!int;
alias Rectu = Rect!uint;
```

---

Rectangle defined by position and size. Origin at upper left.

```d
struct Rect(T) if (isNumeric!T);
```

Fields:

`T x` - X position

`T y` - Y position

`T w` - Width

`T h` - Height

---

Checks if two rectangles intersect.

```d
bool intersects(T)(const Rect!T a, const Rect!T b) @nogc pure nothrow;
```

### `core.vector`

```d
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
```

---

Numeric vector type with an optional amount of components. T can be any numeric type.

```d
struct Vec(T, ulong n) if (n >= 1 && isNumeric!T);
```

Constructors:

Accepts an array of components.

```d
this(U)(U[] elements) @nogc pure nothrow;

const a = Vec2([1f, 2f]);
```

Accepts a variadict list of components, or a single component (all components will have the same value).

```d
this(U...)(U args) @nogc pure nothrow;

const a = Vec2(1f, 2f);
const b = Vec2(1f);
```

Functions:

Vector magnitude

```d
real magnitude() @nogc pure nothrow const;
```

Normalizes the vector. Changes the current struct.

```d
void normalize() @nogc pure nothrow;
```

Returns the normalized vector. Doesn't change the current struct.

```d
Vec!(T, n) normalized() @nogc pure nothrow const;
```

Returns the negated vector.

```d
Vec!(T, n) opUnary(string s)() @nogc pure nothrow const if (s == "-");

const a = Vec2(1f);
const b = -a;
```

Returns the multiplication of this vector and a scalar.

```d
Vec!(T, n) opBinary(string s) (const float scalar) @nogc pure nothrow const if (s == "*");

const a = Vec2(1f, 2f);
auto b = a * 2f;
b *= 3f;
```

Returns the division of this vector and a scalar.

```d
Vec!(T, n) opBinary(string s) (in float scalar) @nogc pure nothrow const if (s == "/");

const a = Vec2(1f, 2f);
auto b = a / 2f;
b /= 3f;
```

Returns the sum of this vector and a scalar.

```d
Vec!(T, n) opBinary(string s) (const float scalar) @nogc pure nothrow const if (s == "+");

const a = Vec2(1f, 2f);
auto b = a + 2f;
b += 3f;
```

Returns the subtraction of this vector and a scalar.

```d
Vec!(T, n) opBinary(string s) (const float scalar) @nogc pure nothrow const if (s == "-");

const a = Vec2(1f, 2f);
auto b = a - 2f;
b -= 3f;
```

Returns the multiplication of 2 vectors. Element wise product `(a, b) * (c, d) = (a*c, b*d)`.

```d
Vec!(T, n) opBinary(string s) (const Vec!(T, n) other) @nogc pure nothrow const if (s == "*");

const a = Vec2(1f, 2f);
const b = Vec2(3f, 4f);

auto c = a * b;
c *= b;
```

Returns the division of 2 vectors. Element wise quotient `(a, b) / (c, d) = (a/c, b/d)`.

```d
Vec!(T, n) opBinary(string s) (const Vec!(T, n) other) @nogc pure nothrow const if (s == "/");

const a = Vec2(1f, 2f);
const b = Vec2(3f, 4f);

auto c = a / b;
c /= b;
```

Get and set the N-th component.

```d
T opIndex(int n) @nogc pure const nothrow;
T opIndexAssign(T value, int n) @nogc pure nothrow;

auto a = Vec2(1f, 2f);
const b = a[0];
a[1] = 3;
```

Internal data as a pointer, can be used for sending data to shaders.

```d
auto ptr() @nogc pure nothrow const;
```

Returns the internal array.

```d
T[n] opIndex() @nogc pure const nothrow;

const a = Vec2(1f, 2f);
const b = a[];
```

Cast to a vector of a different type but same size.

```d
U opCast(U)() pure nothrow const if (is(U : Vec!R, R...) && (U._n == n));

const a = Vec2(1f, 2f);
const b = cast(Vec2i) a;
```

Swizzling, returns a new vector.

```d
Vec!(T, swizzle.length) opDispatch(const string swizzle)() @nogc const pure nothrow;

const a = Vec3(1f, 2f, 3f);
Vec!(5, float) b = a.xxzzy;
b == Vec!(5, float)(1f, 1f, 3f, 3f, 2f);
```

---

Returns the dot product of 2 vectors.

```d
real dot(T, ulong n)(Vec!(T, n) a, Vec!(T, n) b) @nogc pure nothrow;

const a = Vec3(1f, 2f, 3f);
const b = Vec3(4f, 5f, 6f);
const c = dot(a, b);
```

---

Returns the cross product of 2 `Vec3`. The result is always a `Vec3f`.

```d
Vec!(float, 3) cross(T)(Vec!(T, 3) a, Vec!(T, 3) b) @nogc pure nothrow;

const a = Vec3(1f, 2f, 3f);
const b = Vec3(4f, 5f, 6f);
const c cross(a, b);
```

### `dath.matrix`

```d
public alias Mat2f = Mat!(float, 2);
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
```

---

A square matrix. Supports any numeric type.

```d
struct Mat(T, ulong n) if (n >= 2 && isNumeric!T);
```

Constructors:

Variadic list of values or a single value (all elements will have the same value).

```d
this(T...)(T args) @nogc pure nothrow;

const a = Mat2(1f, 2f, 3f, 4f);
const b = Mat2(0f);
```

Functions:

Get and set the value at `[i, j]`.

```d
T opIndex(int i, int j) @nogc pure const nothrow;
T opIndexAssign(T value, int i, int j) @nogc pure nothrow;

auto a = Mat2(1f, 2f, 3f, 4f);
const b = a[0, 1];
a[0, 0] = 5f;
```

Returns the multiplication of this matrix with a scalar.

```d
auto opBinary(string s) (const float scalar) @nogc pure const nothrow if (s == "*");

const a = Mat2(1f, 2f, 3f, 4f);
auto b = a * 2f;
b *= 3f;
```

Returns the multiplication of this matrix with a vector.

```d
auto opBinary(string s) (const Vec!(T, n) vector) @nogc pure const nothrow if (s == "*");

const a = Mat2(1f, 2f, 3f, 4f);
const v = Vec2(2f);
const b = a * v;
```

Returns the multiplication of this matrix and another matrix.

```d
auto opBinary(string s) (const Mat!(T, n) other) @nogc pure const nothrow if (s == "*");

const a = Mat2(1f, 2f, 3f, 4f);
const b = Mat2(5f, 6f, 7f, 8f);
const c = a * b;
```

Returns the subtraction of addition this matrix and another matrix.

```d
auto opBinary(string s) (const Mat!(T, n) other) @nogc pure const nothrow if (s == "+" || s == "-");

const a = Mat2(1f, 2f, 3f, 4f);
const b = Mat2(5f, 6f, 7f, 8f);
const c = a + b;
const d = a - b;
```

Returns the internal data as a pointer, can be used for sending data to shaders.

```d
auto ptr() @nogc pure const nothrow;
```

---

Creates an identity matrix.

```d
Mat!(T, n) identity(T, ulong n)() @nogc pure nothrow;

const a = identity!(float, 2);
```

---

Creates a scaling matrix.

```d
Mat!(T, n) scaling(T, ulong n)(Vec!(T, n-1) v) @nogc pure nothrow;

const a = scaling!(float, 2)(Vec!(float, 1)(3f));
```

---

Creates a rotation matrix, angle in radians.

```d
auto rotation(T)(float angle, Vec!(T, 3) axis) @nogc pure nothrow;

const a = rotation!(float, 2)(1, Vec3(0f, 1f, 0f));
```

---

Creates a translation matrix.

```d
auto translation(T, ulong n)(Vec!(T, n-1) v) @nogc pure nothrow;

const a = translation!(float, 3)(Vec2(4f));
```

---

Creates a look-at matrix.

```d
auto lookAt(Vec3 eye, Vec3 target, Vec3 up) @nogc pure nothrow;
```

---

Creates an orthographic projection matrix.

```d
auto orthographic(float left, float right, float bottom, float top, float near, float far) @nogc pure nothrow;
```

---

Creates a perspective projection matrix.

```d
auto perspective(float fov_in_radians, float aspect, float near, float far) @nogc pure nothrow;
```

---

Returns the inverse of a `Mat4`. If no inverse can be found it returns a `Mat4(inf)`.

```d
Mat4 inverse(const Mat4 a) @nogc pure nothrow;

const a = Mat4(5f, 6f, 6f, 8f, 2f, 2f, 2f, 8f, 6f, 6f, 2f, 8f, 2f, 3f, 6f, 7f);
(inverse(a) * a) == identity!(float , 4);
```
