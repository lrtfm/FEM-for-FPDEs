function v = fd_on_path_v_opt(path, segment, gp_dir, dir, alpha, tol)
    % gp_dir = gp(dir_flag);
    % dir = sum(direction); % + 1 or -1
    if nargin < 6
        tol = 1e-12;
    end
    p1 = path(:, 1:2:end);
    p2 = path(:, 2:2:end);
    seg1 = segment(:, 1:2:end);
    seg2 = segment(:, 2:2:end);
    
    fi = (p2 - p1)./(seg2 - seg1);
    if dir > 0
        interval1 = seg1 - gp_dir;
    else
        interval1 = gp_dir - seg1;
    end
    tmp1 = (dir*alpha(2)*p1 - alpha(3)*fi.*interval1).*interval1.^(-alpha(1));
    if dir > 0
        interval2 = seg2 - gp_dir;
    else
        interval2 = gp_dir - seg2;
    end
    tmp2 = (dir*alpha(2)*p2 - alpha(3)*fi.*interval2).*interval2.^(-alpha(1));
    tmp1(:, 1) = 0;
    v = dir*(tmp2 - tmp1);
    flags = abs(seg2 - seg1) < tol; % fixbugs NaN
    v(:, flags) = 0;
    % d = sparse(1, index_of_nodes, v, 1, num_nodes);
end