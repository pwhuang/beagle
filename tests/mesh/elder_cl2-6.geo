cl = 0.015625;
//+
Point(1) = {0, 0, 0, cl};
//+
Point(2) = {4, 0, 0, cl};
//+
Point(3) = {0, 1, 0, cl};
//+
Point(4) = {4, 1, 0, cl};
//+
Point(5) = {1, 0, 0, cl};
//+
Point(6) = {3, 0, 0, cl};
//+
Line(1) = {3, 1};
//+
Line(2) = {1, 5};
//+
Line(3) = {5, 6};
//+
Line(4) = {6, 2};
//+
Line(5) = {2, 4};
//+
Line(6) = {4, 3};
//+
Line Loop(1) = {6, 1, 2, 3, 4, 5};
//+
Plane Surface(1) = {1};
//+
Physical Line("bottom_half") = {3};
//+
Physical Line("bottom_out") = {2, 4};
//+
Physical Line("right") = {5};
//+
Physical Line("left") = {1};
//+
Physical Line("top") = {6};
//+
Physical Surface("layer1") = {1};
//+
Characteristic Length {5, 6} = cl;
