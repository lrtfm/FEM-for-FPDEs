function compare_two_forms(msg)
    % msg = 'tsfsc_lr_s_beta';

    s0 = load([msg '0.mat']);
    s1 = load([msg '1.mat']);

    result1 = s0.result;
    result2 = s1.result;

    n1 = length(result1);
    n2 = length(result2);
    n = max([n1, n2]);

    steps = 0:0.05:1;
    fun_of_line = @(x)ones(size(x))/2;


    xx = steps;
    x = {xx, fun_of_line(xx), fun_of_line(xx)};
    legend_args = {'Location', 'best', 'Fontsize', 10, 'Interpreter', 'latex'};
    figure('position',[500 300 360 300]);
    st = cell(2*n, 1);
    starts = 1;
    ends = n;
    for i = starts:ends

        % figure('position',[500 300 360 300])
        xxx1 = result1{i}.x;
        F1 = scatteredInterpolant(xxx1{:},result1{i}.u - result1{i}.exact_u);
        v1 = F1(x{:});
        semilogy(xx(2:end-1), abs(v1(2:end-1)), '--','LineWidth',1); hold on;

        xxx2 = result2{i}.x;
        F2 = scatteredInterpolant(xxx2{:},result2{i}.u - result2{i}.exact_u);
        v2 = F2(x{:});
        semilogy(xx(2:end-1), abs(v2(2:end-1)), '-', 'LineWidth',1); hold on;

        st{2*i-1}= sprintf('$h=1/%d$, Form II', 1/result1{i}.dh);
        st{2*i} = sprintf('$h=1/%d$, Form III', 1/result1{i}.dh);

        % 
    end
    legend(st(2*starts-1:2*ends), legend_args{:})

    hgexport(gcf, [msg '_comp'], hgexport('factorystyle'), 'Format', 'epsc');

end
%%
% for i = 1:n
%     figure('position',[500 300 360 300])
%     model = result1{n}.equ.domain.model;
%     u = result1{n}.u;
%     pdeplot3D(model,'ColorMapData',u, 'FaceAlpha',0.5)
% end
