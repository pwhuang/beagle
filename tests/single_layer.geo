//+
Point(1) = {0, 0, 0, 0.05};
//+
Point(2) = {4, 0, 0, 0.05};
//+
Point(3) = {0, 1, 0, 0.05};
//+
Point(4) = {4, 1, 0, 0.05};
//+
Line(1) = {3, 1};
//+
Line(2) = {1, 2};
//+
Line(3) = {2, 4};
//+
Line(4) = {4, 3};
//+
Physical Line("top") = {4};
//+
Physical Line("bottom") = {2};
//+
Physical Line("left") = {1};
//+
Physical Line("right") = {3};
//+
Line Loop(1) = {4, 1, 2, 3};
//+
Plane Surface(1) = {1};
//+
Physical Surface("layer1") = {1};
