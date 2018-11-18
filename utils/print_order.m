function print_order(steps, errors, head)
    % print_order(steps(:), [err_max(:), err_L2(:), err_alpha(:)])
    if size(errors, 1) ~= length(steps)
        error('print_order:row of errors must equal to lenth of steps');
    end
    n = size(errors, 2);
    if nargin < 3
        head = {'$h$', '$\|u-u_h\|_{L^\infty}$', '$\|u-u_h\|_{L^2}$',...
                                         '$|u-u_h|_{\alpha}$'};
        head = head(1:n+1);
    end
    orderstr = repmat({'order'}, 1, n);
    heads = {head{2:end}; orderstr{:}};
    heads = heads(:)';
    heads = [head{1}, heads];
    rates = ConvergenceRate(steps, errors);
    stringFormat = [{'%3s'}, repmat({'%12s', '%5s'}, 1, n)];
    dataFormat = [{'%12g'}, repmat([{'%10.2e'} {'%6.2f'}], 1, n)];
    Print(1, [steps(:) CombineObject(errors, rates)],...
        'Head', heads,...
        'DataFormat', dataFormat, 'StringFormat', stringFormat,...
        'OutputFormat', 'Latex');
end