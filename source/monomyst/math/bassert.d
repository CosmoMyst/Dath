module monomyst.math.bassert;

/++
    Asserts if two values are equal.
    Posts a helpful message when it fails.
+/
void bassert (T) (T value, T result)
{
    import std.string : format;

    assert (value == result, format ("Expected %s, got %s", result, value));
}

/++
    Asserts if two values are approximately equal.
    Posts a helpful message when it fails.
+/
void bassertApprox (T) (T value, T result)
{
    import std.math : approxEqual;
    import std.format : format;

    assert (approxEqual (value, result), format ("Expected approximately %s, got %s", result, value));
}