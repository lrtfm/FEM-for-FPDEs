% main_transient

dim = 2;
isball = 1;
if isball
    % build example on ball
    alpha = repmat(2, dim, 1);
    r = 1/2;
    c_s = ones(dim, 1);
    p = 2;
    c_t = [exp(1)/r^(2*p), -1];
    equ = build_examples_ball(dim, alpha, r, c_s, c_t, p);
    dh = 0.05;
    dt = 0.01;
else
    % build example on cubic
    alpha = repmat(2, dim, 1);
    c_s = ones(dim, 1);
    c_t = [exp(1)*2^(4*dim), -1];
    p = repmat([2, 2], dim, 1);
    equ = build_examples_cubic(dim, alpha, c_s, c_t, p);
    dh = 0.05;
    dt = 0.01;
end

gso = 3;
result = solver_transient(equ, dh, dt, gso);

show_numerical_results(result);
show_errors(result);

