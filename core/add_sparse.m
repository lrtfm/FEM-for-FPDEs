% add_sparse.m Help file for add_sparse MEX-file.
%   add_sparse.c - add sparse matrix in place without allocating new memory.
%
%   The calling syntax is:
%
%       add_sparse(a, b);
%
%   the result will be saved in first parameter a.
%
%   DO NOT CALL THIS FUNCTION LIKE THIS
%       a = add_sparse(a, b);
%