function equ = steady_fpde_case(alpha, p, coeff)
    if nargin < 1
        alpha = repmat(2, 3, 1);
    end

    if nargin < 2
        p = repmat([2, 2], 3, 1);
    end
    
    if nargin < 3
%         coeff = {@(x)ones(size(x{1})), @(x)ones(size(x{1})); 
%                  @(x)ones(size(x{1})), @(x)ones(size(x{1}));
%                  @(x)ones(size(x{1})), @(x)ones(size(x{1}))};
        coeff.fun = {@(x)ones(1, size(x, 2)), @(x)ones(1, size(x, 2)); 
                     @(x)ones(1, size(x, 2)), @(x)ones(1, size(x, 2));
                     @(x)ones(1, size(x, 2)), @(x)ones(1, size(x, 2))};
        coeff.df = {@(x)zeros(1, size(x, 2)), @(x)zeros(1, size(x, 2)); 
                     @(x)zeros(1, size(x, 2)), @(x)zeros(1, size(x, 2));
                     @(x)zeros(1, size(x, 2)), @(x)zeros(1, size(x, 2))};
    end
    
    model = create_cubic_model(1);
    domain.model = model;
    domain.model_flag = 1;
    domain.x_range = repmat([0, 1], 3, 1); % range_fun(cell(3, 1));

    equ = build_equation(alpha, p, @range_fun, coeff);
    equ.domain = domain;
    equ.T = 1;
    equ.steps = 0:0.05:1;
    equ.slices = 1/2;
        [x, y, z] = meshgrid(0.01:0.02:1);
    equ.watch_points = [x(:)'; y(:)'; z(:)'];
end

function range = range_fun(x)
	n = length(x);
	range = repmat({0, 1}, n, 1);
end

function equ = build_equation(alpha, p, range_fun, coeff)

    equ.alpha = alpha;
    equ.p = p;
    equ.range_fun = range_fun;
    equ.coeff = coeff;
    equ.real_solution = @(x, t)2^sum(sum(p))*get_real_solution(x, range_fun, p);
    equ.source_term = @(x, t)2^sum(sum(p))*get_source_term(x, range_fun, p, alpha, coeff);
end

function u = get_real_solution(x, range_fun, p)
    % get_real_solution
    % input:
    %     x_range = {x1_min, x1_max; x2_min, x2_max; ...; xn_min, xn_max}
    %     p = [p1_1, p1_2; p2_1, p2_2; ...; pn_1, pn_2]
    %
    x_range = range_fun(x);
    n = length(x);
    tmp = cell(n, 1);
    for i = 1:n
        tmp{i} = ((x{i} - x_range{i, 1}).^p(i, 1)).*((x_range{i, 2} - x{i}).^p(i, 2));
    end
    u = fold(@times, tmp);
end

function f = get_source_term(x, range_fun, p, alpha, coeff)
    % U = T * X * Y; 
    x_range = range_fun(x);
    n = length(x);
    tmp = cell(n, 1);
    for i = 1:n
        tmp{i} = ((x{i} - x_range{i, 1}).^p(i, 1)).*((x_range{i, 2} - x{i}).^p(i, 2));
    end
    
    x_array = cell2mat(x)';
    derivative = cell(n, 1);
    for i = 1:n
        R = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p(i, 1), p(i, 2), alpha(i), 'R');
        L = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p(i, 1), p(i, 2), alpha(i), 'L');

        R2 = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p(i, 1), p(i, 2), alpha(i)-1, 'R');
        L2 = get_fd_of_polynomial(x{i}, x_range{i, 1}, x_range{i, 2}, p(i, 1), p(i, 2), alpha(i)-1, 'L');
        derivative{i} = coeff.fun{i, 1}(x_array)'.*L - coeff.fun{i, 2}(x_array)'.*R ...
                        + coeff.df{i, 1}(x_array)'.*L2 + coeff.df{i, 2}(x_array)'.*R2;
    end

    d_x = cell(n, 1);
    for i = 1:n
        tmp2 = tmp;
        tmp2{i} = derivative{i};
        d_x{i} = fold(@times, tmp2);
    end
    f = fold(@plus, d_x);
end