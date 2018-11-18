/*********************************************************************
 *
 *  Gmsh geometry file, generate by matlab.
 *
 *  Constructive Solid Geometry, OpenCASCADE geometry kernel
 *
 *********************************************************************/

SetFactory("OpenCASCADE");

Box(1) = {0,0,0, 1,1,1};
Box(2) = {0,0,0, 0.5,0.5,0.5};
BooleanDifference(3) = { Volume{1}; Delete; }{ Volume{2}; Delete; };

lc = 0.2;
Characteristic Length{ PointsOf{ Volume{:}; } } = lc;