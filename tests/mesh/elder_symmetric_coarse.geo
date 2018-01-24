cl_1 = 0.08;
cl_2 = 0.03;
//+
Point(1) = {0, 0, 0, cl_1};
//+
Point(2) = {4, 0, 0, cl_1};
//+
Point(3) = {0, 1, 0, cl_1};
//+
Point(4) = {4, 1, 0, cl_1};
//+
Point(5) = {1, 0, 0, cl_2};
//+
Point(6) = {3, 0, 0, cl_2};
//+
Line(1) = {3, 1};
//+
Line(2) = {1, 5};
//+
Line(4) = {6, 2};
//+
Line(5) = {2, 4};
//+
Physical Line("bottom_out") = {2, 4};
//+
Physical Line("right") = {5};
//+
Physical Line("left") = {1};
//+
Point(7) = {2, 1, 0, cl_1};
//+
Point(8) = {2, 0, 0, cl_2};
//+
Line(6) = {3, 7};
//+
Line(7) = {7, 4};
//+
Line(8) = {5, 8};
//+
Line(9) = {8, 6};
//+
Line(10) = {7, 8};
//+
Line Loop(1) = {6, 10, -8, -2, -1};
//+
Plane Surface(1) = {1};
//+
Line Loop(2) = {7, -5, -4, -9, -10};
//+
Plane Surface(2) = {2};
//+
Physical Line("top") = {6, 7};
//+
Physical Line("bottom_half") = {8, 9};
//+
Physical Surface("layer1") = {1, 2};
