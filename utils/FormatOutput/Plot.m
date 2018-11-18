function Plot(h, x, data, varargin)
    nVargin = length(varargin);
    legendflag = 0;
    xlabelflag = 0;
    ylabelflag = 0;
    xlimflag = 0;
    ylimflag = 0;
    linetypesflag = 0;
    titleflag = 0;
    i = 1;
    while i <= nVargin
        switch lower(varargin{i})
            case 'title'
                Title = varargin{i+1};
                titleflag = 1;
            case 'legend'
                Legend = varargin{i+1};
                legendflag = 1;
            case 'xlabel'
                Xlabel = varargin{i+1};
                xlabelflag = 1;
            case 'ylabel'
                Ylabel = varargin{i+1};
                ylabelflag = 1;
            case 'xlim'
                Xlim = varargin{i+1};
                xlimflag = 1;
            case 'ylim'
                Ylim = varargin{i+1};
                ylimflag = 1;
            case 'linetypes'
                Linetypes = varargin{i+1};
                linetypesflag = 1;
            otherwise
                % error
        end
        i = i + 2;
    end
    
    [~, m] = size(data);
    for i = 1:m
        if linetypesflag == 1
            plot(x, data(:, i), Linetypes{i});
        else
            plot(x, data(:, i));
        end
        hold on;
    end
    grid on
    if legendflag == 1
        legend(Legend,'Location', 'best', 'Fontsize', 10, 'Interpreter', 'latex')
    end
    if xlabelflag == 1
        xlabel(Xlabel, 'interpreter', 'latex', 'fontsize', 12);
    end
    if ylabelflag == 1
        ylabel(Ylabel, 'interpreter', 'latex', 'fontsize', 12);
    end
    if xlimflag == 1
        xlim(Xlim);
    end
    if ylimflag == 1
        ylim(Ylim);
    end
    if titleflag == 1
        title(Title,'interpreter', 'latex', 'fontsize', 12);
    end
end
