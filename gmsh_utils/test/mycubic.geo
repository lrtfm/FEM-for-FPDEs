/*********************************************************************
 *
 *  Gmsh geometry file, generate by matlab.
 *
 *  Constructive Solid Geometry, OpenCASCADE geometry kernel
 *
 *********************************************************************/

SetFactory("OpenCASCADE");

Box(1) = {0,0,0, 1,1,1};
lc = 0.3;
Characteristic Length{ PointsOf{ Volume{:}; } } = lc;