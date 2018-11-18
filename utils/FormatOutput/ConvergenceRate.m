function rates = ConvergenceRate(steps, errors)
    % length(steps) == size(errors, 1);
    
    steps = steps(:);
    n = length(steps);
    [en, em] = size(errors);
    if n ~= en
        error('FormatOutput.ConvergenceRate: length(steps) ~= size(errors, 1)');
    end
    rates = zeros(size(errors));
    if n > 1
        logsteps =  repmat(log2(steps(2:n)./steps(1:(n-1))), 1, em);
        rates(2:n,:) = log2(errors(2:n, :)./errors(1:(n-1), :)) ./ logsteps;
    end
end