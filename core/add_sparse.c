// FileName: add_sparse.c (part of project fem4fpde-3d)
// Description: add sparse matrix in place without reallocating memory.
//              And the first parameter should be the sparse template for
//              the second one, i.e. the index of the nonzero element of
//              the second matrix must be a nonzero index of the first
//              matrix. Be cautious in using it.
//
//              Use command `mex -largeArrayDims add_sparse.c` to build
//              it in matlab.
//
// Author: Yang Zongze (yangzongze@gmail.com)
// Date:   2018/05/15

#include "mex.h"
void add_sparse(const mxArray *prhs0, const mxArray *prhs1);
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    if (nlhs != 0 && nrhs != 2) {
        mexErrMsgIdAndTxt( "MATLAB:mexfunction:addSparse", \
                           "input output wrong!!!\n");
    }
    add_sparse(prhs[0], prhs[1]);
    // plhs[0] = prhs[0];  // Cause error in MatLab 2017b
}

void add_sparse(const mxArray *prhs0, const mxArray *prhs1)
{
    double *sr0;
    mwIndex *irs0,*jcs0;
    double *sr1;
    mwIndex *irs1,*jcs1;
    size_t m0, n0, m1, n1;
    size_t num0, index0, num1, index1;
    size_t i, j, k, j0, j1;

    m0 = mxGetM(prhs0);
    n0 = mxGetN(prhs0);
    sr0  = mxGetPr(prhs0);
    irs0 = mxGetIr(prhs0);
    jcs0 = mxGetJc(prhs0);

    m1 = mxGetM(prhs1);
    n1 = mxGetN(prhs1);
    sr1  = mxGetPr(prhs1);
    irs1 = mxGetIr(prhs1);
    jcs1 = mxGetJc(prhs1);
    if (m0 != m1 || n0 != n1) {
        mexErrMsgIdAndTxt( "MATLAB:mexfunction:addSparse", \
                           "Dimension not match!!!\n");
    }

    for (i = 0; i < n0; ++i) {
        num1 = jcs1[i+1];
        j0 = jcs0[i];
        j1 = jcs1[i];

        while (j1 < num1) {
            if (sr1[j1] == 0) {
                j1++;
                continue;
            }
            index0 = irs0[j0];
            index1 = irs1[j1];

            while (index0 < index1) {
                j0++;
                index0 = irs0[j0];
            }
            if (index0 != index1) {
                mexErrMsgIdAndTxt( "MATLAB:mexfunction:addSparse", \
                                   "Template must be error!!!\n");
            }
            sr0[j0] = sr0[j0] + sr1[j1];
            j0++;
            j1++;
        }
    }
}
