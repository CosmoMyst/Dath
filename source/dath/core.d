module dath.core;

public const double PI = 3.14159265358979323846;

/++
 + converts deg to rad
 +/
@nogc float rad(float deg) pure nothrow {
    return deg * (PI / 180);
}

/++
 + converts rad to deg
 +/
@nogc float deg(float rad) pure nothrow {
    return rad * 180 / PI;
}
