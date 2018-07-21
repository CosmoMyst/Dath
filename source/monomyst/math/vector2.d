module monomyst.math.vector2;

/// Vector2 struct
struct Vector2
{
    private float [4] v;

    /// The X component of a vector
    @property float x () { return v [0]; }
    /// ditto
    @property float x (float value) { return v [0] = value; }

    /// The Y component of a vector
    @property float y () { return v [1]; }
    /// ditto
    @property float y (float value) { return v [1] = value; }

    /// Constructs a Vector3 using X, Y and Z components
    this (float x, float y)
    {
        this.x = x;
        this.y = y;
        v [2] = 0;
        v [3] = 0;
    }
}

unittest
{
    Vector2 vector = Vector2 (43, 56);
    assert (vector.x == 43 && vector.y == 56);
}