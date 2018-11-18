function D = get_fd_of_polynomial(x, Xmin, Xmax, p1, p2, alpha, type)
% get_fd_of_polynomial Compute fractional derivates of polynomial
%           (x - Xmin)^p1 * (Xmax - x)^p2 
% at x. It is used to build fractional numerical examples.
% Input: 
%       type: 'L' left derivative, 'R' right derivative.
    
    if type == 'L'
        X = x - Xmin;
        X(X < 0) = 0;
        Y = Xmax - Xmin;
        k = 0:p2;
        D = (-1).^k .* gamma(p1 + k + 1) .* arrayfun(@(x)nchoosek(p2, x), k) .* Y.^(p2 - k) .* X.^k;
        D = D * (1 ./ gamma(p1 + k + 1 - alpha))' .* X.^(p1 - alpha);
    elseif type == 'R'
        X = Xmax - x;
        X(X < 0) = 0;
        Y = Xmax - Xmin;
        k = 0:p1;
        D = (-1).^k .* gamma(p2 + k + 1) .* arrayfun(@(x)nchoosek(p1, x), k) .* Y.^(p1 - k) .* X.^k;
        D = D * (1 ./ gamma(p2 + k + 1 - alpha))' .* X.^(p2 - alpha);
    else
        error('get_fd_of_polynomial:unknown type : %s', type)
    end
end
