cl__1 = 0.1;
cl__2 = 0.02;
Point(1) = {0, 0, 0, cl__2};
Point(2) = {1.0, 0, 0, cl__1};
Point(4) = {1.0, 1, 0, cl__1};
Point(6) = {0, 1, 0, cl__1};
Point(7) = {0.5, 0, 0, cl__2};
Point(8) = {0, 0.5, 0, cl__2};
Line(2) = {2, 4};
Line(3) = {4, 6};
Line(4) = {6, 8};
Line(5) = {1, 8};
Line(12) = {1, 7};
Line(13) = {7, 2};
Physical Line("top") = {3};
Physical Line("right") = {2};
Physical Line("left") = {4, 5};
Physical Line("bottom_left") = {12};
Physical Line("bottom_right") = {13};
//+
Line Loop(1) = {3, 4, -5, 12, 13, 2};
//+
Plane Surface(1) = {1};
//+
Physical Surface("layer1") = {1};
