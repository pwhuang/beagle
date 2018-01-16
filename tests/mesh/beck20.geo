cl = 0.05;
//+
Point(1) = {0, 0, 0, cl};
//+
Point(2) = {2, 0, 0, cl};
//+
Point(3) = {2, 0, 0.5, cl};
//+
Point(4) = {0, 0, 0.5, cl};
//+
Point(5) = {0, 1, 0, cl};
//+
Point(6) = {0, 1, 0.5, cl};
//+
Point(7) = {2, 1, 0.5, cl};
//+
Point(8) = {2, 1, 0, cl};
//+
Line(1) = {4, 6};
//+
Line(2) = {6, 5};
//+
Line(3) = {5, 1};
//+
Line(4) = {1, 4};
//+
Line(5) = {4, 3};
//+
Line(6) = {3, 7};
//+
Line(7) = {7, 8};
//+
Line(8) = {8, 2};
//+
Line(9) = {2, 3};
//+
Line(10) = {1, 2};
//+
Line(11) = {5, 8};
//+
Line(12) = {6, 7};
//+
Line Loop(1) = {12, 7, -11, -2};
//+
Plane Surface(1) = {1};
//+
Line Loop(2) = {11, 8, -10, -3};
//+
Plane Surface(2) = {2};
//+
Line Loop(3) = {7, 8, 9, 6};
//+
Plane Surface(3) = {3};
//+
Line Loop(4) = {12, -6, -5, 1};
//+
Plane Surface(4) = {4};
//+
Line Loop(5) = {2, 3, 4, 1};
//+
Plane Surface(5) = {5};
//+
Line Loop(6) = {9, -5, -4, 10};
//+
Plane Surface(6) = {6};
//+
Surface Loop(1) = {1, 4, 3, 2, 6, 5};
//+
Volume(1) = {1};
//+
Physical Surface("right") = {3};
//+
Physical Surface("left") = {5};
//+
Physical Surface("front") = {1};
//+
Physical Surface("back") = {6};
//+
Physical Surface("top") = {4};
//+
Physical Surface("bottom") = {2};
//+
Physical Volume("layer1") = {1};
