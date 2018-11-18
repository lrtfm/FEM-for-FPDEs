function show_errors(result)    
    figure('position', [300, 300, 720, 300]);
    subplot(1, 2, 1)
    plot_field(result, 'e_max', '$\|u-u_h\|_{L^\infty}$');
    title('(a)');
    subplot(1, 2, 2)
    plot_field(result, 'e_L2', '$\|u-u_h\|_{L^2}$')
    title('(b)');
%     subplot(1, 3, 3)
%     plot_field(result, 'e_alpha')
end

function plot_field(r, f, msg)
    if isfield(r, f)
        T = r.equ.T;
        dt = r.dt;
        m = floor(T/dt);
        x = dt*(1:m);
        plot(x, r.(f));
        xlabel('$t$', 'Interpreter', 'latex', 'Fontsize', 14);
        ylabel(msg, 'Interpreter', 'latex', 'Fontsize', 14);
    else
        warning('field %s non exist in r', f);
    end
end