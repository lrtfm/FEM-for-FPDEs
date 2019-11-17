function e = error_energy_norm(u_handle, uh, mesh_info, qformula)
    tstart = tic;
    dim = size(mesh_info.nodes, 1);
    alpha = qformula.alpha;
    w = qformula.w;
    I = eye(dim);
    e = 0;
    for i = 1:dim
        direction = I(:, i); 
        e = e + error_energy_norm_inner(u_handle, uh, mesh_info, ...
                                 alpha/2, direction, ...
                                 alpha/2, -direction);
    end
    e = w*e/cos(alpha*pi);
    tend = toc(tstart);
    fprintf('GET_MK used time: %s\n', calendarDuration(0,0,0,0,0, tend));
    e = sqrt(abs(e));
end


function e = error_energy_norm_inner(u_handle, uh, mesh_info, ...
                                 alpha, alpha_dir, ...
                                 beta, beta_dir, ...
                                 fun, gso, msg, tol)
    if nargin < 9
        gso = 4;
    end
    if nargin < 8
        fun = 1;
    end
    if nargin < 11
        tol = 10^(-10);
    end
    if nargin < 10
        dir_fmt = get_direction_fmt(alpha_dir);
        fmt = ['(%g:', dir_fmt, ')'];
        fmts = ['EEN:', fmt, ', ', fmt];
        msg = sprintf(fmts, alpha, alpha_dir, beta, beta_dir);
    end
    gamma_alpha = [alpha, 1/gamma(1-alpha), 1/gamma(2-alpha)];
    gamma_beta = [beta, 1/gamma(1-beta), 1/gamma(2-beta)];

    if isparallel()
        e = een_inner_p(u_handle, uh, mesh_info, gamma_alpha, alpha_dir, ...
                                      gamma_beta, beta_dir, fun,...
                                      gso, msg, tol);
    else
        e = een_inner(u_handle, uh, mesh_info, gamma_alpha, alpha_dir, ...
                              gamma_beta, beta_dir, fun,...
                              gso, msg, tol);
    end

end

function e = een_inner(u_handle, uh, mesh_info, gamma_alpha, alpha_dir, ...
                              gamma_beta, beta_dir, fun,...
                              gso, msg, tol)
    number_of_elements = size(mesh_info.elements, 2);
    % [gpsv, ~, num_of_gp] = get_gauss_points_area_represent(gso);
    [w, gps, gp, num_of_gp] = get_weights_for_integral_on_elements(...
                              mesh_info, fun, gso);
    
    Timer = MyTimer(number_of_elements, 100, msg);
    Timer.beginwatch();
    e = 0;
    for index = 1:number_of_elements
        gauss_points = gps{index};
        left = fds_on_paths_dispatch(u_handle, uh, mesh_info, index, ...
                                     gauss_points, gp, num_of_gp, ...
                                     gamma_alpha, alpha_dir,...
                                     tol);
        right = fds_on_paths_dispatch(u_handle, uh, mesh_info, index, ...
                                     gauss_points, gp, num_of_gp, ...
                                     gamma_beta, beta_dir,...
                                     tol);
        e = e + w(:, index)'*(right.*left);
        Timer = Timer.watch(index);
    end
    Timer.endwatch();
    e = sqrt(e);
end

function ret = een_inner_p(u_handle, uh, mesh_info, gamma_alpha, alpha_dir, ...
                                 gamma_beta, beta_dir, fun,...
                                 gso, msg, tol)
    number_of_elements = size(mesh_info.elements, 2);
    msg = [msg '(NE:' num2str(number_of_elements) ')'];

    spmd
        e = 0;
        % [gpsv, ~, num_of_gp] = get_gauss_points_area_represent(gso);
        [w, gps, gp, num_of_gp] = get_weights_for_integral_on_elements(...
                                  mesh_info, fun, gso);
        if labindex == 1
            Timer = MyTimer(ceil(number_of_elements/numlabs), 100, msg);
            Timer.beginwatch();
        end
        for index = labindex:numlabs:number_of_elements
            gauss_points = gps{index};
            left = fds_on_paths_dispatch(u_handle, uh, mesh_info, index, ...
                                         gauss_points, gp, num_of_gp, ...
                                         gamma_alpha, alpha_dir,...
                                         tol);
            right = fds_on_paths_dispatch(u_handle, uh, mesh_info, index, ...
                                         gauss_points, gp, num_of_gp, ...
                                         gamma_beta, beta_dir,...
                                         tol);
            e = e + w(:, index)'*(right.*left);
            if labindex == 1
                Timer = Timer.watch((index - labindex)/numlabs);
            end
        end
        if labindex == 1
            Timer.endwatch();
        end
    end
    spmd
        es = gplus(e, 1);
    end
    ret = es{1};
end

function left = fds_on_paths_dispatch(u_handle, uh, mesh_info, index_of_element, ...
                                      gauss_points, gpsv, m, ...
                                      gamma_alpha, alpha_dir,...
                                      tol)
    if gamma_alpha(1) > 0 && gamma_alpha(1) < 1
        left = fds_on_gps(u_handle, uh, mesh_info, index_of_element, gauss_points, ...
             gamma_alpha, alpha_dir, tol);
        return
    end
    
    error('Not Implement for these parameters!');
    number_of_nodes = size(mesh_info.nodes, 2);
    indeice = mesh_info.elements(:, index_of_element);
    index_row = kron((1:m)', ones(size(indeice)));
    index_col = repmat(indeice, m, 1);
    
    if gamma_alpha(1) == 0
        value = gpsv(:);
    elseif gamma_alpha(1) == 1
        df = get_first_order_derivatives_on_element(...
                mesh_info, index_of_element, alpha_dir);
        value = repmat(df, m, 1);
    else  
        error('fds_on_paths_dispatch_new:alpha must be in [0, 1]')
    end
    
    left = sparse(index_row, index_col, value, m, number_of_nodes);
end

function left = fds_on_gps(u_handle, uh, mesh_info, index, gps, alpha, direction, tol)
    num_of_gp = size(gps, 2);
    dir = sum(direction);
    left = zeros(num_of_gp, 1);
    nodes = mesh_info.nodes;
    elements = mesh_info.elements;
    for i = 1:num_of_gp
        [path, ie, ~] = get_path(mesh_info, index, gps(:, i), ...
                      direction, tol);
        segment = zeros(size(path, 1)-1, size(path, 2));
        for k = 1:length(ie)
            sind = 2*k-1:2*k;
            segment(:, sind) = nodes(:, elements(:, ie(k)))*path(:, sind);
        end
        ue = u_handle(segment);
        tmp = [1:length(ie); 1:length(ie)];
        ie2 = ie(tmp(:));
        iof2 = elements(:, ie2);
        un = sum(path.*uh(iof2));
        gp_dir = gps(direction~=0,i);
        left(i) = fd_on_gp(ue'-un, segment(direction~=0, :), gp_dir, dir, alpha);
    end
end

function ret = fd_on_gp(u, segment, gp_dir, dir, alpha, tol)
    % gp_dir = gp(dir_flag);
    % dir = sum(direction); % + 1 or -1
    if nargin < 6
        tol = 1e-12;
    end
    p1 = u(1:2:end);
    p2 = u(2:2:end);
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
    ret = sum(v);
    % d = sparse(1, index_of_nodes, v, 1, num_nodes);
end
