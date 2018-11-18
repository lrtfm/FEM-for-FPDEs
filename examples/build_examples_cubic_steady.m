function equ = build_examples_cubic_steady(dim, alpha, c_s, p)
% build_examples_cubic_steady build numerical examples for equation
%          \[ - Lu = f \quad \text{on} \quad \varOmega \]
% where $\varOmega = [0, 1]^{dim}$, and
%          \[ L = \sum_{i=1}^{dim} c_s(i) {}^{Rz}D^\alpha_{x_i}. \]
% The real solution is
%  \[ u(x, t) = \prod_{i=1}^{dim} x_i^{p(i, 1)}(1 - x_i)^{p(i, 2)}.\]
%
% Output:
%       equ.get_mesh: function handle, result value is mesh
%                     can be called like this
%                            equ.get_mesh(h).
%       equ.source_term: function handle of f, input must be cell, every
%                          element of cell contain data of one dimension.
%       equ.real_solution: function handle of u, input same with f.

                      
    if nargin < 2
        alpha = repmat(2, dim, 1);
    end
    if nargin < 3
        c_s = ones(dim, 1);
    end
    if nargin < 4
        p = repmat([2, 2], dim, 1);
    end

    [mesh_fun, range_fun] = get_mesh_fun_cubic(dim);
    equ = build_equation(alpha, c_s, p, range_fun);
    equ.dboundary_fun = equ.real_solution;
    equ.get_mesh = mesh_fun;
    equ.T = 1;
    equ.dim = dim;
    equ.steps = 0:0.05:1;
    equ.slices = 1/2;
end

function equ = build_equation(alpha, c_s, p, range_fun)
    equ.c_s = c_s;
    equ.alpha = alpha;
    equ.range_fun = range_fun;
    equ.real_solution = @(x)2^(sum(p(:)))*get_real_solution(x, range_fun, p);
    equ.source_term = @(x)2^(sum(p(:)))*get_source_term(x, range_fun, p, c_s, alpha);
end

function u = get_real_solution(x, range_fun, p)
    x_range = range_fun(x);
    n = length(x);
    tmp = cell(n, 1);
    for i = 1:n
        tmp{i} = ((x{i} - x_range{i, 1}).^p(i, 1)).*((x_range{i, 2} - x{i}).^p(i, 2));
    end
    u = fold(@times, tmp);
end

function f = get_source_term(x, range_fun, p, c_s, alpha)
    x_range = range_fun(x);
    n = length(x);
    tmp = cell(n, 1);
    for i = 1:n
        tmp{i} = ((x{i} - x_range{i, 1}).^p(i, 1)).*((x_range{i, 2} - x{i}).^p(i, 2));
    end

    derivative = cell(n, 1);
    for i = 1:n
        L = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p(i, 1), p(i, 2), alpha(i), 'L');
        R = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p(i, 1), p(i, 2), alpha(i), 'R');
        derivative{i} = -c_s(i) * (L + R) / (2.0*cos(alpha(i)*pi/2.0));
    end

    d_x = cell(n, 1);
    for i = 1:n
        tmp2 = tmp;
        tmp2{i} = derivative{i};
        d_x{i} = fold(@times, tmp2);
    end
    f = - fold(@plus, d_x);
end
