function Z = CombineObject(errors, rates)
    if isnumeric(errors)
        [m, n] = size(errors);
        Z = zeros([m 2*n]);
        Z(:, 1:2:end) = errors;
        Z(:, 2:2:end) = rates;
    elseif iscell(errors)
        [m, n] = size(errors);
        Z = cell([m 2*n]);
        for i = 1:n
            Z{:, 2*i-1} = errors{:, i};
            Z{:, 2*i} = rates{:, i};
        end
    end
        
end



