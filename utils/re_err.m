function re = re_err(K1_i, K2_i, tol)
    if nargin < 3
        tol = 1e-12;
    end
    ae = abs(K1_i - K2_i);
    nzflag = abs(K1_i) > tol;
    re = ae./abs(K1_i);
    re(~nzflag) = 0;
end
