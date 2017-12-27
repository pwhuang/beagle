cl__1 = 0.4;
cl__2 = 0.05;
cl__3 = 0.4;
//+
Point(1) = {0, 0, 0, cl__1};
//+
Point(2) = {4, 0, 0, cl__1};
//+
Point(3) = {4, 0, 4, cl__1};
//+
Point(4) = {0, 0, 4, cl__1};
//+
Point(5) = {0, 1, 0, cl__3};
//+
Point(6) = {4, 1, 0, cl__3};
//+
Point(7) = {4, 1, 4, cl__3};
//+
Point(8) = {0, 1, 4, cl__3};
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
Physical Surface("top") = {1};
//+
Physical Surface("front") = {3};
//+
Physical Surface("back") = {5};
//+
Physical Surface("right") = {2};
//+
Physical Surface("left") = {4};
//+
Point(13) = {2, 0, 2, cl__1};
//+
Point(14) = {2, 0, 3, cl__2};
//+
Point(15) = {2, 0, 1, cl__2};
//+
Point(16) = {3, 0, 2, cl__2};
//+
Point(17) = {1, 0, 2, cl__2};
//+
Line(13) = {12, 14};
//+
Line(14) = {14, 11};
//+
Line(15) = {11, 16};
//+
Line(16) = {16, 10};
//+
Line(17) = {10, 15};
//+
Line(18) = {15, 9};
//+
Line(19) = {9, 17};
//+
Line(20) = {17, 12};
//+
Line(21) = {17, 13};
//+
Line(22) = {13, 16};
//+
Line(23) = {13, 13};
//+
Line(24) = {14, 13};
//+
Line(25) = {13, 15};
//+
Line Loop(8) = {17, 18, 19, 20, 13, 14, 15, 16};
//+
Plane Surface(6) = {6, 8};
//+
Line Loop(9) = {13, 24, -21, 20};
//+
Plane Surface(7) = {9};
//+
Line Loop(10) = {14, 15, -22, -24};
//+
Plane Surface(8) = {10};
//+
Line Loop(11) = {16, 17, -25, 22};
//+
Plane Surface(9) = {11};
//+
Line Loop(12) = {19, 21, 25, 18};
//+
Plane Surface(10) = {12};
//+
Physical Surface("bottom_out") = {6};
//+
Physical Surface("bottom_in") = {7, 8, 10, 9};
//+
Surface Loop(1) = {6, 2, 1, 3, 4, 5, 9, 10, 7, 8};
//+
Volume(1) = {1};
//+
Physical Volume("layer1") = {1};
