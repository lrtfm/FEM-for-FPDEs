// FileName: gip.c (part of project fem4fpde-3d)
// Description: get intersection point of ray and simplex
//
//              Use command `mex -o get_intersect_point_mex gip.c` to build
//              it in matlab.
//
// Author: Yang Zongze (yangzongze@gmail.com)
// Date:   2018/11/03

#include "mex.h"
int get_intersection(size_t n, double * A_inv, double * origin,\
       double * start_point, double * direction, double * tol,\
       double * p, double * r_max);
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    if (nrhs != 5) {
        mexErrMsgIdAndTxt( "MATLAB:mexfunction:gip.c", \
                           "input arg number is wrong!!!\n");
    }
    double *A_inv, *origin, *start_point, *direction, *tol;
    size_t n;
    double *p, *r_max;

    n = mxGetM(prhs[0]);
    A_inv  = mxGetPr(prhs[0]);
    origin  = mxGetPr(prhs[1]);
    start_point = mxGetPr(prhs[2]);
    direction = mxGetPr(prhs[3]);
    tol = mxGetPr(prhs[4]);

    plhs[0] = mxCreateDoubleMatrix(n+1, 2, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    p = mxGetPr(plhs[0]);
    r_max = mxGetPr(plhs[1]);
    *r_max = 999;
    if (get_intersection(n, A_inv, origin, start_point, direction, tol,\
            p, r_max) == 0){
        plhs[0] = mxCreateDoubleMatrix(n+1, 0, mxREAL);
    }
}

int get_intersection(size_t n, double * A_inv, double * origin,\
       double * start_point, double * direction, double * tol,\
       double * p, double * r_max)
{
    int flag;
    size_t i;
    size_t len = n + 1;
    double v1[4];
    double v2[4];
    double r[4];
    double vect[4];
    double r_min;
    flag = 0;
    r_min = 0; 
    vect[0] = start_point[0] - origin[0];
    vect[1] = start_point[1] - origin[1];
    if (n > 2) vect[2] = start_point[2] - origin[2];

    if (n == 3) {
#define mymul(k,what)  A_inv[k]*what[0] + A_inv[k+3]*what[1] + \
        A_inv[k+6]*what[2]
        v1[0] = mymul(0, vect);
        v1[1] = mymul(1, vect);
        v1[2] = mymul(2, vect);
        v2[0] = mymul(0, direction);
        v2[1] = mymul(1, direction);
        v2[2] = mymul(2, direction);

        v1[3] = 1 - (v1[0] + v1[1] + v1[2]);
        v2[3] = - (v2[0] + v2[1] + v2[2]);
#undef mymul
    } else {// n == 2
#define mymul(k,what)  A_inv[k]*what[0] + A_inv[k+2]*what[1] 
        v1[0] = mymul(0, vect);
        v1[1] = mymul(1, vect);
        v2[0] = mymul(0, direction);
        v2[1] = mymul(1, direction);
        v1[2] = 1 - (v1[0] + v1[1]);
        v2[2] = - (v2[0] + v2[1]);
#undef mymul
    }

    for (i = 0; i < len; ++i){
        r[i] = - v1[i]/v2[i];
        if (v2[i] < - *tol) {
            if (r[i] < *r_max) {
                *r_max = r[i];
            }
        } else if (v2[i] > *tol) {
            if (r[i] > r_min) {
                r_min = r[i];
            }
        } else { 
            if (v1[i] < - *tol) {
                return 0;
            }
        }
    }
    if (*r_max > r_min) {
        if (n == 3) {
            p[0] = v1[0] + v2[0]*r_min;
            p[1] = v1[1] + v2[1]*r_min;
            p[2] = v1[2] + v2[2]*r_min;
            p[3] = v1[3] + v2[3]*r_min;
            p[4] = v1[0] + v2[0]* *r_max;
            p[5] = v1[1] + v2[1]* *r_max;
            p[6] = v1[2] + v2[2]* *r_max;
            p[7] = v1[3] + v2[3]* *r_max;
        } else {
            p[0] = v1[0] + v2[0]*r_min;
            p[1] = v1[1] + v2[1]*r_min;
            p[2] = v1[2] + v2[2]*r_min;
            p[3] = v1[0] + v2[0]* *r_max;
            p[4] = v1[1] + v2[1]* *r_max;
            p[5] = v1[2] + v2[2]* *r_max;
        }
        return 1;
    } 
    return 0;
}
