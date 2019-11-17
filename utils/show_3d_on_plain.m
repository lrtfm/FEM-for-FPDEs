function show_3d_on_plain(result, real_solution, xx, yy, fun_of_plain, msg)
    k = 20;
    x = {xx, yy, fun_of_plain(xx)};
    for i = 1:length(result)
        ret = result{i};
        F = scatteredInterpolant(ret.x{:},ret.u);
        v = F(x{:});
        figure('position',[500 300 360 300])
        % [cs, h] = contour(xx, yy, v, 10, 'ShowText', 'on');
        % h.LevelList = round(h.LevelList, 1);
        [~, h] = contourf(xx, yy, v, k);
        h.LineStyle='none';
        axis equal;
        colorbar
            xlabel('$x_1$', 'Fontsize', 14, 'Interpreter', 'latex');
    ylabel('$x_2$', 'Fontsize', 14, 'Interpreter', 'latex');
        hgexport(gcf, [msg '_' int2str(i), '.eps'], hgexport('factorystyle'), 'Format', 'epsc');
    end
    v = real_solution(x);
    figure('position',[500 300 360 300])
    [~, h] = contourf(xx, yy, v, k);
    h.LineStyle='none';
    axis equal
    colorbar
    xlabel('$x_1$', 'Fontsize', 14, 'Interpreter', 'latex');
    ylabel('$x_2$', 'Fontsize', 14, 'Interpreter', 'latex');
    hgexport(gcf, [msg '_' int2str(length(result)+1), '.eps'], hgexport('factorystyle'), 'Format', 'epsc');

end