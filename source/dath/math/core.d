module dath.core;

/++
 + converts deg to rad
 +/
@nogc float rad(float deg) pure nothrow {
    import std.math : PI;

    return deg * (PI / 180);
}

/++
 + converts rad to deg
 +/
@nogc float deg(float rad) pure nothrow {
    import std.math : PI;

    return rad * 180 / PI;
}
