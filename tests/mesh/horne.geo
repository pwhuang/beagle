cl__1 = 0.02;
Point(1) = {0, 0, 0, cl__1};
Point(2) = {0.7, 0, 0, cl__1};
Point(4) = {0.7, 1, 0, cl__1};
Point(6) = {0, 1, 0, cl__1};
Point(7) = {0.35, 0, 0, 0.0075};
Line(2) = {2, 4};
Line(3) = {4, 6};
Line(4) = {6, 1};
Line(12) = {1, 7};
Line(13) = {7, 2};
Line Loop(15) = {3, 4, 12, 13, 2};
Plane Surface(15) = {15};
Physical Line("top") = {3};
Physical Line("right") = {2};
Physical Line("left") = {4};
Physical Line("bottom_left") = {12};
Physical Line("bottom_right") = {13};
Physical Surface("layer1") = {15};
