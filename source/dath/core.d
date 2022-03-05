module dath.core;

public const double PI = 3.14159265358979323846;

/++
 + Converts deg to rad.
 +/
public float rad(float deg) @nogc pure nothrow {
    return deg * (PI / 180);
}

/++
 + Converts rad to deg.
 +/
public float deg(float rad) @nogc pure nothrow {
    return rad * 180 / PI;
}
