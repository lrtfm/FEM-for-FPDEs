function equ = build_examples_ball(dim, alpha, r, c_s, c_t, p)
%%%  build_examples_ball build numerical examples on ball
% build numerical examples for equation
% 
% $$ c*u_t - Lu = f \quad \rm{on} \quad \Omega $$
% 
% where $\Omega = B(0, r)$, and
%
% $$ L = \sum_{i=1}^{\rm dim} c_s(i) {}^{Rz}D^\alpha_{x_i}. $$
%
% The real solution is
%
% $$ u(x, t) = c_t(1)e^{c_t(2)t} ( \sum_i^{\rm dim} x_i^2 - r^2 )^p $$
%
% 
%%% Output:
% *    equ.get_mesh: function handle, result value is mesh
%                     can be called like this
%                            equ.get_mesh(h).
% *    equ.source_term: function handle of f, input must be cell, every
%                          element of cell contain data of one dimension.
% *    equ.real_solution: function handle of u, input same with f.

    if nargin < 2
        alpha = repmat(2, dim, 1);
    end
    if nargin < 3
        r = 1;
    end
    if nargin < 4
        c_s = ones(dim, 1);
    end
    if nargin < 5
        c_t = [exp(1)/r^4, -1];
    end
    if nargin < 6
        p = 2;
    end
    
    [mesh_fun, range_fun] = get_mesh_fun_ball(dim, r);
    equ = build_equation(alpha, c_s, c_t, p, range_fun, r);
    equ.get_mesh = mesh_fun;
    equ.dim = dim;
    equ.T = 1;
    equ.steps = -r:0.1:r;
    equ.slices = 0;
end

%%% build equation, real solution and source term
function equ = build_equation(alpha, c_s, c_t, p, range_fun, r)
    equ.c_s = c_s;
    equ.c_t = c_t;
    equ.alpha = alpha;
    equ.range_fun = range_fun;
    equ.real_solution = @(x, t)get_real_solution(x, t, range_fun, c_t, p, r);
    equ.source_term = @(x, t)get_source_term(x, t, range_fun, c_t, p, c_s, alpha, r);
end

function u = get_real_solution(x, t, ~, c_t, p, r)
    T = c_t(1)*exp(c_t(2) * t);
    tmp = fold(@plus, cellfun(@(x)x.^2, x, 'UniformOutput', false));
    % tmp = (x{1}.^2 + x{2}.^2 + x{3}.^2 - 1).^p;
    u = T * (tmp - r.^2).^p;
end

function f = get_source_term(x, t, range_fun, c_t, p, c_s, alpha, r)
    x_range = range_fun(x);
    T = c_t(1)*exp(c_t(2) * t);
    Tt = c_t(2) * T;
    n = length(x);
    tmp = fold(@plus, cellfun(@(x)x.^2, x, 'UniformOutput', false));
    u_t = Tt * (tmp - r.^2).^p;

    derivative = cell(n, 1);
    for i = 1:n
        L = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p, p, alpha(i), 'L');
        R = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p, p, alpha(i), 'R');
        derivative{i} = -c_s(i) * (L + R) / (2.0*cos(alpha(i)*pi/2.0));
    end

    f = u_t - T * fold(@plus, derivative);
end
