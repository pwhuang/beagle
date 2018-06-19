cl__1 = 0.1;
cl__2 = 0.05;
//+
Point(1) = {0, 0, 0, cl__1};
//+
Point(2) = {1, 0, 0, cl__1};
//+
Point(3) = {1, 1, 0, cl__1};
//+
Point(4) = {0, 1, 0, cl__1};
//+
Point(5) = {0, 0.4, 0, cl__2};
//+
Point(6) = {0, 0.6, 0, cl__2};
//+
Point(7) = {1, 0.6, 0, cl__2};
//+
Point(8) = {1, 0.4, 0, cl__2};
//+
Line(1) = {4, 3};
//+
Line(2) = {3, 7};
//+
Line(3) = {7, 8};
//+
Line(4) = {8, 2};
//+
Line(5) = {2, 1};
//+
Line(6) = {1, 5};
//+
Line(7) = {5, 6};
//+
Line(8) = {6, 4};
//+
Line(9) = {6, 7};
//+
Line(10) = {8, 5};
//+
Line Loop(1) = {1, 2, -9, 8};
//+
Plane Surface(1) = {1};
//+
Line Loop(2) = {9, 3, 10, 7};
//+
Plane Surface(2) = {2};
//+
Line Loop(3) = {5, 6, -10, 4};
//+
Plane Surface(3) = {3};
//+
Physical Line("top") = {1};
//+
Physical Line("bottom") = {5};
//+
Physical Line("left") = {8, 7, 6};
//+
Physical Line("right") = {2, 3, 4};
