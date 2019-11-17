function equ = build_circle_example(alpha, r, c_s, c_t, p)
    % equ = build_circle_example(repmat(2, 3, 4), 1, [1, 1, 1], [1, -1], 2)
    if nargin < 1
        alpha = repmat(2, 3, 1);
    end
    if nargin < 2
        r = 1;
    end
    if nargin < 3
        c_s = [1, 1, 1];
    end
    if nargin < 4
        c_t = [exp(1), -1];
    end
    if nargin < 5
        p = 2;
    end
    model = create_circle_model(r);
    domain.model = model;
    domain.model_flag = 1;
    % domain.x_range = repmat([0, 1], 3, 1); % range_fun(cell(3, 1));

    equ = build_equation(alpha, c_s, c_t, p, @(x)range_fun(x,r^2));
    equ.domain = domain;
    equ.T = 1;
    equ.steps = -r:0.1:r;
    equ.slices = 0;
end

function range = range_fun(x, r2)
	% n = length(x);
	% range = repmat({0, 1}, n, 1);
    % r2 = 1;
    range = cell(3, 2);
    xx = x{1}.^2;
    yy = x{2}.^2;
    zz = x{3}.^2;
    a = r2 - yy - zz;
    b = r2 - xx - zz;
    c = r2 - xx - yy;
    a(a < 0) = 0;
    b(b < 0) = 0;
    c(c < 0) = 0;
    range{1, 2} = sqrt(a);
    range{1, 1} = - range{1, 2};
    range{2, 2} = sqrt(b);
    range{2, 1} = - range{2, 2};
    range{3, 2} = sqrt(c);
    range{3, 1} = - range{3, 2};
end

function equ = build_equation(alpha, c_s, c_t, p, range_fun)
    equ.c_s = c_s;
    equ.c_t = c_t;
    equ.alpha = alpha;
    equ.range_fun = range_fun;
    equ.real_solution = @(x, t)get_real_solution(x, t, range_fun, c_t, p);
    equ.source_term = @(x, t)get_source_term(x, t, range_fun, c_t, p, c_s, alpha);
end

function u = get_real_solution(x, t, ~, c_t, p)
    % get_real_solution
    % input:
    %     x_range = {x1_min, x1_max; x2_min, x2_max; ...; xn_min, xn_max}
    %     p = [p1_1, p1_2; p2_1, p2_2; ...; pn_1, pn_2]
    %
    % x_range = range_fun(x);
    T = c_t(1)*exp(c_t(2) * t);
    % n = length(x);
    tmp = (x{1}.^2 + x{2}.^2 + x{3}.^2 - 1).^p;
    u = T * tmp;
end

function f = get_source_term(x, t, range_fun, c_t, p, c_s, alpha)
    % U = T * X * Y; 
    x_range = range_fun(x);
    T = c_t(1)*exp(c_t(2) * t);
    Tt = c_t(2) * T;
    n = length(x);
    tmp = (x{1}.^2 + x{2}.^2 + x{3}.^2 - 1).^p;
    u_t = Tt * tmp;

    derivative = cell(n, 1);
    for i = 1:n
        L = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p, p, alpha(i), 'L');
        R = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p, p, alpha(i), 'R');
        derivative{i} = -c_s(i) * (L + R) / (2.0*cos(alpha(i)*pi/2.0));
    end

    f = u_t - T * fold(@plus, derivative);
end


