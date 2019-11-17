function D = get_fd_of_polynomial(x, Xmin, Xmax, p1, p2, alpha, type)
    % Compute fractional derivates of (x - Xmin)^p1 * (Xmax - x)^p2
    %
    % type 'L' 'R'
    
    D = 0;
    if type == 'L'
        X = x - Xmin;
        X(X < 0) = 0;
        for i = 0:p2
            g = gamma(p1 + i + 1)/gamma(p1 + i + 1 - alpha);
            D = D + (-1)^i * g * nchoosek(p2, i) * (Xmax - Xmin).^(p2 - i) .* X.^(p1 + i - alpha); 
        end
    elseif type == 'R'
        X = Xmax - x;
        X(X < 0) = 0;
        for i = 0:p1
            g = gamma(p2 + i + 1)/gamma(p2 + i + 1 - alpha);
            D = D + (-1)^i * g * nchoosek(p1, i) * (Xmax - Xmin).^(p1 - i) .* X.^(p2 + i - alpha); 
        end
    else
        error('get_fd_of_polynomial:unknown type : %s', type)
    end
end