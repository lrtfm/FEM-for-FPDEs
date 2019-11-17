function equ = build_rect_example(alpha, c_s, c_t, p)
    if nargin < 1
        alpha = repmat(2, 3, 1);
    end
    if nargin < 2
        c_s = [1, 1, 1];
    end
    if nargin < 3
        c_t = [exp(1)*2^12, -1];
    end
    if nargin < 4
        p = repmat([2, 2], 3, 1);
    end
    
    model = create_cubic_model(1);
    domain.model = model;
    domain.model_flag = 0;
    domain.x_range = repmat([0, 1], 3, 1); % range_fun(cell(3, 1));

    equ = build_equation(alpha, c_s, c_t, p, @range_fun);
    equ.domain = domain;
    equ.T = 1;
    equ.steps = 0:0.05:1;
    equ.slices = 1/2;
end

function range = range_fun(x)
	n = length(x);
	range = repmat({0, 1}, n, 1);
end

function equ = build_equation(alpha, c_s, c_t, p, range_fun)
    equ.c_s = c_s;
    equ.c_t = c_t;
    equ.alpha = alpha;
    equ.range_fun = range_fun;
    equ.real_solution = @(x, t)get_real_solution(x, t, range_fun, c_t, p);
    equ.source_term = @(x, t)get_source_term(x, t, range_fun, c_t, p, c_s, alpha);
end

function u = get_real_solution(x, t, range_fun, c_t, p)
    % get_real_solution
    % input:
    %     x_range = {x1_min, x1_max; x2_min, x2_max; ...; xn_min, xn_max}
    %     p = [p1_1, p1_2; p2_1, p2_2; ...; pn_1, pn_2]
    %
    x_range = range_fun(x);
    T = c_t(1)*exp(c_t(2) * t);
    n = length(x);
    tmp = cell(n, 1);
    for i = 1:n
        tmp{i} = ((x{i} - x_range{i, 1}).^p(i, 1)).*((x_range{i, 2} - x{i}).^p(i, 2));
    end
    u = T * fold(@times, tmp);
end

function f = get_source_term(x, t, range_fun, c_t, p, c_s, alpha)
    % U = T * X * Y; 
    x_range = range_fun(x);
    T = c_t(1)*exp(c_t(2) * t);
    Tt = c_t(2) * T;
    n = length(x);
    tmp = cell(n, 1);
    for i = 1:n
        tmp{i} = ((x{i} - x_range{i, 1}).^p(i, 1)).*((x_range{i, 2} - x{i}).^p(i, 2));
    end
    u_t = Tt * fold(@times, tmp);

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
    f = u_t - T * fold(@plus, d_x);
end
