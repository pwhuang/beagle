cl__1 = 0.1;
cl__2 = 0.025;
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
Point(6) = {0, 1, 4, cl__1};
//+
Point(7) = {4, 1, 4, cl__1};
//+
Point(8) = {4, 1, 0, cl__1};
//+
Point(9) = {1, 0, 1, cl__2};
//+
Point(10) = {3, 0, 1, cl__2};
//+
Point(11) = {3, 0, 3, cl__2};
//+
Point(12) = {1, 0, 3, cl__2};
//+
Point(13) = {2, 0, 1, cl__2};
//+
Point(14) = {3, 0, 2, cl__2};
//+
Point(15) = {2, 0, 3, cl__2};
//+
Point(16) = {1, 0, 2, cl__2};
//+
Point(17) = {2, 0, 2, cl__2};
//+
Point(18) = {2, 0, 0, cl__2};
//+
Point(19) = {4, 0, 2, cl__1};
//+
Point(20) = {2, 0, 4, cl__1};
//+
Point(21) = {0, 0, 2, cl__1};
//+
Point(22) = {0, 1, 2, cl__1};
//+
Point(23) = {2, 1, 4, cl__1};
//+
Point(24) = {4, 1, 2, cl__1};
//+
Point(25) = {2, 1, 0, cl__1};
//+
Point(26) = {2, 1, 2, cl__1};
//+
Line(1) = {5, 25};
//+
Line(2) = {25, 8};
//+
Line(3) = {8, 24};
//+
Line(4) = {24, 7};
//+
Line(5) = {7, 23};
//+
Line(6) = {23, 6};
//+
Line(7) = {6, 22};
//+
Line(8) = {22, 5};
//+
Line(9) = {5, 1};
//+
Line(10) = {1, 18};
//+
Line(11) = {18, 2};
//+
Line(12) = {2, 19};
//+
Line(13) = {19, 3};
//+
Line(14) = {3, 7};
//+
Line(15) = {3, 20};
//+
Line(16) = {20, 4};
//+
Line(17) = {4, 21};
//+
Line(18) = {21, 1};
//+
Line(19) = {6, 4};
//+
Line(20) = {9, 16};
//+
Line(21) = {16, 12};
//+
Line(22) = {12, 15};
//+
Line(23) = {15, 11};
//+
Line(24) = {11, 14};
//+
Line(25) = {14, 10};
//+
Line(26) = {10, 13};
//+
Line(27) = {13, 9};
//+
Line(28) = {25, 26};
//+
Line(29) = {26, 23};
//+
Line(30) = {23, 20};
//+
Line(31) = {20, 15};
//+
Line(32) = {15, 17};
//+
Line(33) = {17, 13};
//+
Line(34) = {13, 18};
//+
Line(35) = {18, 25};
//+
Line(36) = {26, 17};
//+
Line(37) = {17, 14};
//+
Line(38) = {14, 19};
//+
Line(39) = {19, 24};
//+
Line(40) = {24, 26};
//+
Line(41) = {26, 22};
//+
Line(42) = {22, 21};
//+
Line(43) = {21, 16};
//+
Line(44) = {16, 17};
//+
Line Loop(1) = {1, 28, 41, 8};
//+
Plane Surface(1) = {1};
//+
Line Loop(2) = {2, 3, 40, -28};
//+
Plane Surface(2) = {2};
//+
Line Loop(3) = {4, 5, -29, -40};
//+
Plane Surface(3) = {3};
//+
Line Loop(4) = {41, -7, -6, -29};
//+
Plane Surface(4) = {4};
//+
Physical Surface("top") = {2, 1, 4, 3};
//+
Line Loop(5) = {22, 32, -44, 21};
//+
Plane Surface(5) = {5};
//+
Line Loop(6) = {23, 24, -37, -32};
//+
Plane Surface(6) = {6};
//+
Line Loop(7) = {37, 25, 26, -33};
//+
Plane Surface(7) = {7};
//+
Line Loop(8) = {44, 33, 27, 20};
//+
Plane Surface(8) = {8};
//+
Line Loop(9) = {15, 31, 23, 24, 38, 13};
//+
Plane Surface(9) = {9};
//+
Line Loop(10) = {38, -12, -11, -34, -26, -25};
//+
Plane Surface(10) = {10};
//+
Line Loop(11) = {16, 17, 43, 21, 22, -31};
//+
Plane Surface(11) = {11};
//+
Line Loop(12) = {43, -20, -27, 34, -10, -18};
//+
Plane Surface(12) = {12};
//+
Physical Surface("bottom_out") = {11, 12, 10, 9};
//+
Physical Surface("bottom_in") = {5, 6, 8, 7};
//+
Line(45) = {8, 2};
//+
Line Loop(17) = {41, 42, 43, 44, -36};
//+
Plane Surface(17) = {17};
//+
Line Loop(18) = {40, 36, 37, 38, 39};
//+
Plane Surface(18) = {18};
//+
Physical Surface("inner_surface_z") = {17, 18};
//+
Line Loop(19) = {28, 36, 33, 34, 35};
//+
Plane Surface(19) = {19};
//+
Line Loop(20) = {29, 30, 31, 32, -36};
//+
Plane Surface(20) = {20};
//+
Physical Surface("inner_surface_x") = {19, 20};
//+
Line Loop(21) = {4, -14, -13, 39};
//+
Plane Surface(21) = {21};
//+
Line Loop(22) = {3, -39, -12, -45};
//+
Plane Surface(22) = {22};
//+
Physical Surface("right") = {21, 22};
//+
Line Loop(23) = {8, 9, -18, -42};
//+
Plane Surface(23) = {23};
//+
Line Loop(24) = {7, 42, -17, -19};
//+
Plane Surface(24) = {24};
//+
Physical Surface("left") = {23, 24};
//+
Line Loop(25) = {6, 19, -16, -30};
//+
Plane Surface(25) = {25};
//+
Line Loop(26) = {5, 30, -15, 14};
//+
Plane Surface(26) = {26};
//+
Physical Surface("front") = {25, 26};
//+
Line Loop(27) = {1, -35, -10, -9};
//+
Plane Surface(27) = {27};
//+
Line Loop(28) = {2, 45, -11, 35};
//+
Plane Surface(28) = {28};
//+
Physical Surface("back") = {27, 28};
//+
Surface Loop(1) = {27, 1, 23, 12, 8, 28, 2, 22, 10, 7, 3, 21, 26, 9, 6, 4, 24, 11, 25, 5};
//+
Volume(1) = {1};
//+
Physical Volume("layer1") = {1};
