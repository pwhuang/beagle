cl__1 = 0.02;
Point(1) = {0, 0, 0, cl__1};
Point(2) = {0.7, 0, 0, cl__1};
Point(4) = {0.7, 1, 0, cl__1};
Point(6) = {0, 1, 0, cl__1};
Line(2) = {2, 4};
Line(3) = {4, 6};
Line(4) = {6, 1};
Physical Line("top") = {3};
Physical Line("right") = {2};
Physical Line("left") = {4};
Line(16) = {1, 2};
Line Loop(17) = {3, 4, 16, 2};
Plane Surface(18) = {17};
Physical Surface("layer1") = {18};
Physical Line("bottom") = {16};
