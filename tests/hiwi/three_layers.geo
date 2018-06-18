cl__1 = 0.05;
cl__2 = 0.04;
//+
Point(1) = {0, 0, 0, cl__1};
//+
Point(2) = {1, 0, 0, cl__1};
//+
Point(3) = {0, 1, 0, cl__1};
//+
Point(4) = {1, 1, 0, cl__1};
//+
Point(5) = {0, 0, 1, cl__1};
//+
Point(6) = {1, 0, 1, cl__1};
//+
Point(7) = {0, 1, 1, cl__1};
//+
Point(8) = {1, 1, 1, cl__1};
//+
Line(1) = {1, 5};
//+
Line(2) = {5, 6};
//+
Line(3) = {6, 2};
//+
Line(4) = {2, 1};
//+
Line(5) = {3, 7};
//+
Line(6) = {7, 8};
//+
Line(7) = {8, 4};
//+
Line(8) = {4, 3};
//+
Point(9) = {0, 0.4, 0, cl__2};
//+
Point(10) = {1, 0.4, 0, cl__2};
//+
Point(11) = {0, 0.4, 1, cl__2};
//+
Point(12) = {1, 0.4, 1, cl__2};
//+
Point(13) = {0, 0.6, 0, cl__2};
//+
Point(14) = {1, 0.6, 0, cl__2};
//+
Point(15) = {0, 0.6, 1, cl__2};
//+
Point(16) = {1, 0.6, 1, cl__2};
//+
Line(9) = {7, 15};
//+
Line(10) = {15, 16};
//+
Line(11) = {16, 14};
//+
Line(12) = {14, 4};
//+
Line(13) = {3, 13};
//+
Line(14) = {13, 15};
//+
Line(15) = {13, 14};
//+
Line(16) = {14, 10};
//+
Line(17) = {10, 2};
//+
Line(18) = {13, 9};
//+
Line(19) = {9, 1};
//+
Line(20) = {15, 11};
//+
Line(21) = {11, 5};
//+
Line(22) = {16, 12};
//+
Line(23) = {12, 6};
//+
Line(24) = {11, 12};
//+
Line(25) = {12, 10};
//+
Line(26) = {10, 9};
//+
Line(27) = {9, 11};
//+
Line(28) = {8, 16};
//+
Line Loop(1) = {6, 7, 8, 5};
//+
Plane Surface(1) = {1};
//+
Line Loop(2) = {15, -11, -10, -14};
//+
Plane Surface(2) = {2};
//+
Line Loop(3) = {26, 27, 24, 25};
//+
Plane Surface(3) = {3};
//+
Line Loop(4) = {4, 1, 2, 3};
//+
Plane Surface(4) = {4};
//+
Line Loop(5) = {7, -12, -11, -28};
//+
Plane Surface(5) = {5};
//+
Line Loop(6) = {11, 16, -25, -22};
//+
Plane Surface(6) = {6};
//+
Line Loop(7) = {25, 17, -3, -23};
//+
Plane Surface(7) = {7};
//+
Line Loop(8) = {8, 13, 15, 12};
//+
Plane Surface(8) = {8};
//+
Line Loop(9) = {15, 16, 26, -18};
//+
Plane Surface(9) = {9};
//+
Line Loop(10) = {26, 19, -4, -17};
//+
Plane Surface(10) = {10};
//+
Line Loop(11) = {5, 9, -14, -13};
//+
Plane Surface(11) = {11};
//+
Line Loop(12) = {14, 20, -27, -18};
//+
Plane Surface(12) = {12};
//+
Line Loop(13) = {27, 21, -1, -19};
//+
Plane Surface(13) = {13};
//+
Line Loop(14) = {6, 28, -10, -9};
//+
Plane Surface(14) = {14};
//+
Line Loop(15) = {10, 22, -24, -20};
//+
Plane Surface(15) = {15};
//+
Line Loop(16) = {24, 23, -2, -21};
//+
Plane Surface(16) = {16};
//+
Surface Loop(1) = {1, 14, 5, 8, 11, 2};
//+
Volume(1) = {1};
//+
Surface Loop(2) = {2, 9, 6, 15, 12, 3};
//+
Volume(2) = {2};
//+
Surface Loop(3) = {10, 13, 16, 7, 4, 3};
//+
Volume(3) = {3};
//+
Physical Surface("top") = {1};
//+
Physical Surface("bottom") = {4};
//+
Physical Surface("left") = {11, 13};
//+
Physical Surface("right") = {5, 7};
//+
Physical Surface("front") = {14, 16};
//+
Physical Surface("back") = {8, 10};
//+
Physical Volume("top_layer") = {1};
//+
Physical Volume("mid_layer") = {2};
//+
Physical Volume("bot_layer") = {3};
