cl__1 = 0.1;
cl__2 = 0.05;
//+
Point(1) = {0, 0, 0, cl__1};
//+
Point(2) = {4, 0, 0, cl__1};
//+
Point(3) = {4, 0, 4, cl__1};
//+
Point(4) = {0, 0, 4, cl__1};
//+
Point(5) = {0, 1, 0, cl__1};
//+
Point(6) = {4, 1, 0, cl__1};
//+
Point(7) = {4, 1, 4, cl__1};
//+
Point(8) = {0, 1, 4, cl__1};
//+
Point(9) = {1, 0, 1, cl__2};
//+
Point(10) = {3, 0, 1, cl__2};
//+
Point(11) = {3, 0, 3, cl__2};
//+
Point(12) = {1, 0, 3, cl__2};
//+
Line(1) = {5, 6};
//+
Line(2) = {6, 7};
//+
Line(3) = {7, 3};
//+
Line(4) = {3, 2};
//+
Line(5) = {2, 6};
//+
Line(6) = {5, 1};
//+
Line(7) = {1, 2};
//+
Line(8) = {5, 8};
//+
Line(9) = {8, 4};
//+
Line(10) = {4, 1};
//+
Line(11) = {4, 3};
//+
Line(12) = {8, 7};
//+
Line(13) = {12, 11};
//+
Line(14) = {11, 10};
//+
Line(15) = {10, 9};
//+
Line(16) = {9, 12};
//+
Line Loop(1) = {2, -12, -8, 1};
//+
Plane Surface(1) = {1};
//+
Line Loop(2) = {2, 3, 4, 5};
//+
Plane Surface(2) = {2};
//+
Line Loop(3) = {12, 3, -11, -9};
//+
Plane Surface(3) = {3};
//+
Line Loop(4) = {8, 9, 10, -6};
//+
Plane Surface(4) = {4};
//+
Line Loop(5) = {1, -5, -7, -6};
//+
Plane Surface(5) = {5};
//+
Line Loop(6) = {4, -7, -10, 11};
//+
Line Loop(7) = {13, 14, 15, 16};
//+
Plane Surface(7) = {6, 7};
//+
Plane Surface(8) = {7};
//+
Physical Surface("top") = {1};
//+
Physical Surface("right") = {3};
//+
Physical Surface("left") = {5};
//+
Physical Surface("back") = {4};
//+
Physical Surface("front") = {2};
//+
Physical Surface("bottom_in") = {8};
//+
Physical Surface("bottom_out") = {7};
//+
Surface Loop(1) = {1, 2, 3, 7, 5, 4, 8};
//+
Volume(1) = {1};
//+
Physical Volume("layer1") = {1};
