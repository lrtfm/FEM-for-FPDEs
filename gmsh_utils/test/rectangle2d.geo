lc = 0.1
Point(1) = {-100, 100, 0, lc};
Point(2) = {100, 100, 0, lc};
Point(3) = {100, -100, 0, lc};
Point(4) = {-100, -100, 0, lc};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};
Line Loop(6) = {4, 1, 2, 3};
Plane Surface(6) = {6};