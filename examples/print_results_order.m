function print_results_order(result)
    len = length(result);
    dh = zeros(len, 1);
    e_max = zeros(len, 1);
    e_L2 = zeros(len, 1);
    e_alpha = zeros(len, 1);
    for i = 1:len
        e_max(i) = result{i}.e_max(end);
        e_L2(i) = result{i}.e_L2(end);
        e_alpha(i) = result{i}.e_alpha(end);
        dh(i) = result{i}.dh;
    end

    print_order(dh(:), [e_max(:), e_L2(:), e_alpha(:)])
end