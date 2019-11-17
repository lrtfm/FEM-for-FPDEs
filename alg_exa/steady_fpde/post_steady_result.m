function post_steady_result(some_result, msg)
    print_inner(some_result);

    equ = some_result{1}.equ;
    steps = 0:0.05:1;
    tmp_fun = @(x)ones(size(x))/2;

    show_3d_on_line(some_result, equ.real_solution, steps, tmp_fun, 0);
    hgexport(gcf, [msg '_line' ], hgexport('factorystyle'), 'Format', 'epsc');

    show_3d_errors_on_line(some_result, steps, tmp_fun);
    hgexport(gcf, [msg '_line_error' ], hgexport('factorystyle'), 'Format', 'epsc');

    steps = 0:0.025:1;
    [xx, yy] = meshgrid(steps, steps);
    show_3d_on_plain(some_result, @(x)equ.real_solution(x, 1), xx, yy, tmp_fun, msg);
end

function print_inner(result)
    n = length(result);
    e_max = zeros(1, n);
    e_L2 = zeros(1, n);
    re_max = zeros(1, n);
    dh = zeros(1, n);
    for i = 1:n
        dh(i) = result{i}.dh;
        e_max(i) = result{i}.e_max;
        e_L2(i) = result{i}.e_L2;
        re = re_err(result{i}.exact_u, result{i}.u, 1e-2);
        re_max(i) = max(max(re));
    end

    data = [e_max(:), e_L2(:), re_max(:)*100];
    print_order(dh(:), data)
end