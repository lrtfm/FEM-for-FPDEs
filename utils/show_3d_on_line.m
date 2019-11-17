function show_3d_on_line(result, real_solution, steps, fun_of_line, what)
    figure('position',[500 300 360 300])
    % linespec = {'.b', '--r', '*', '-'};
    %A = {[ 55, 126, 184]*.85;[228, 26, 28];[ 77, 175, 74];[ 255, 127, 0];[ 152, 78, 163]};
    %color_cell =cellfun(@(x)x./255, A, 'UniformOutput',false); % *0.8 + (1-0.8)
    % maker_cell = {'.',  '*', 'd', 'x', 'o'};
    linespec = {'.b', '--r', '*m', '--o', '.k'};
    % linespec =  {'--db', '--or', '--*k', '--xm', '--ok', '--*m'};
    % linespec = {'--xb', '--dr', '--sk', '--*m', '-k'};
    xx = steps;
    x = {xx, fun_of_line(xx), fun_of_line(xx)};
    n = length(result);
    for i = 1:n
        ret = result{i};
        F = scatteredInterpolant(ret.x{:},ret.u);
        v = F(x{:});

        plot(xx, v, linespec{i}, 'LineWidth',1); hold on;
    end
    v = real_solution(x);
    plot(xx, v, '-k', 'LineWidth',1);
    
    if nargin < 5
        return
    end
    
    ylim([0, 1.2])
    n = length(result);
    st = cell(n, 1);
    for i = 1:length(result)
        st{i} = sprintf('$h=1/%d$', 1/result{i}.dh);
    end
    st{n+1} = 'exact solution';
    legend_args = {'Location', 'best', 'Fontsize', 10, 'Interpreter', 'latex'};
    legend(st, legend_args{:})
    xlabel('$x_1$', 'Fontsize', 14, 'Interpreter', 'latex');
    ylabel('$u_h$', 'Fontsize', 14, 'Interpreter', 'latex');
end