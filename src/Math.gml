#define EaseOutQuad(t, b, c, d)
t = t / d;
return -c * t * (t - 2) + b;

#define EaseOutBack(t, b, c, d)
var s = 1.70158;
t = t / d - 1;
return c * (t * t * ((s + 1) * t + s) + 1) + b;