module dath.rect;

/++
 + rectangle definition, origin at upper left.
 +/
struct Rect {
    float x;
    float y;
    float w;
    float h;
}

/++
 + rectangle definition, origin at upper left. uses integers.
 +/
struct RectI {
    int x;
    int y;
    int w;
    int h;
}
