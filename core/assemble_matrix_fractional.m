function K = assemble_matrix_fractional(mesh_info, ...
                                 alpha, alpha_dir, ...
                                 beta, beta_dir, ...
                                 fun, gso, msg, tol)
% assemble_matrix_fractional_inner assemble the fractional stiffness matrix
%    This function compute the inner product 
%               $(fun*D^alpha_{alpha_dir} u, D^beta_{beta_dir} v)$
%    and where alpha_dir and beta_dir are directions of the fractional 
%    derivatives.
%
%       K = assemble_matrix_fractional(mesh_info, ...
%                               alpha, alpha_dir, beta, beta_dir, fun,...
%                               gso, msg, tol)
%
    if nargin < 9
        tol = 10^(-10);
    end
    if nargin < 8
        dir_fmt = get_direction_fmt(direction);
        fmt = ['(%g:', dir_fmt, ')'];
        fmts = ['AMF:', fmt, ', ', fmt];
        msg = sprintf(fmts, alpha, alpha_dir, beta, beta_dir);
    end
    gamma_alpha = [alpha, 1/gamma(1-alpha), 1/gamma(2-alpha)];
    gamma_beta = [beta, 1/gamma(1-beta), 1/gamma(2-beta)];

    if isparallel()
        K = amf_inner_p(mesh_info, gamma_alpha, alpha_dir, ...
                                      gamma_beta, beta_dir, fun,...
                                      gso, msg, tol);
    else
        K = amf_inner(mesh_info, gamma_alpha, alpha_dir, ...
                              gamma_beta, beta_dir, fun,...
                              gso, msg, tol);
    end
    if get_matrix_correct_flag(alpha, alpha_dir, beta, beta_dir)
        K = -K;
    end
end

function K = amf_inner(mesh_info, gamma_alpha, alpha_dir, ...
                                  gamma_beta, beta_dir, fun,...
                                  gso, msg, tol)
    number_of_elements = size(mesh_info.elements, 2);
    number_of_nodes = size(mesh_info.nodes, 2);

    T = get_matrix_template(mesh_info, alpha_dir);
    K = zeros(number_of_nodes, number_of_nodes, 'like', T);
    K = K + T;
    % [gpsv, ~, num_of_gp] = get_gauss_points_area_represent(gso);
    [w, gps, gp, num_of_gp] = get_weights_for_integral_on_elements(...
                              mesh_info, fun, gso);
    
    Timer = MyTimer(number_of_elements, 100, msg);
    Timer.beginwatch();
    for index = 1:number_of_elements
        gauss_points = gps{index};
        left = fds_on_paths_dispatch(mesh_info, index, ...
                                     gauss_points, gp, num_of_gp, ...
                                     gamma_alpha, alpha_dir,...
                                     tol);
        right = fds_on_paths_dispatch(mesh_info, index, ...
                                     gauss_points, gp, num_of_gp, ...
                                     gamma_beta, beta_dir,...
                                     tol);
        Ke = right'*spdiags(w(:, index), 0, num_of_gp, num_of_gp)*left;
        add_sparse(K, Ke); % K = add_sparse(K, Ke);
        Timer = Timer.watch(index);
    end
    Timer.endwatch();
    K = K - T;
end

function K_ret = amf_inner_p(mesh_info, gamma_alpha, alpha_dir, ...
                                 gamma_beta, beta_dir, fun,...
                                 gso, msg, tol)
    number_of_elements = size(mesh_info.elements, 2);
    number_of_nodes = size(mesh_info.nodes, 2);
    T = get_matrix_template(mesh_info, alpha_dir);
    msg = [msg '(NE:' num2str(number_of_elements) ')'];
    spmd
        K = zeros(number_of_nodes, number_of_nodes, 'like', T);
        K = K + T;
        % [gpsv, ~, num_of_gp] = get_gauss_points_area_represent(gso);
        [w, gps, gp, num_of_gp] = get_weights_for_integral_on_elements(...
                                  mesh_info, fun, gso);
        if labindex == 1
            Timer = MyTimer(ceil(number_of_elements/numlabs), 100, msg);
            Timer.beginwatch();
        end

        for index = labindex:numlabs:number_of_elements
            gauss_points = gps{index};
            left = fds_on_paths_dispatch(mesh_info, index, ...
                                         gauss_points, gp, num_of_gp, ...
                                         gamma_alpha, alpha_dir,...
                                         tol);
            right = fds_on_paths_dispatch(mesh_info, index, ...
                                         gauss_points, gp, num_of_gp, ...
                                         gamma_beta, beta_dir,...
                                         tol);
            Ke = right'*spdiags(w(:, index), 0, num_of_gp, num_of_gp)*left;
            add_sparse(K, Ke); % K = add_sparse(K, Ke);
            if labindex == 1
                Timer = Timer.watch((index - labindex)/numlabs);
            end
        end
        if labindex == 1
            Timer.endwatch();
        end
        K = K - T;
    end
    spmd
        KS = gplus(K, 1);
    end
    K_ret = KS{1};
end

function left = fds_on_paths_dispatch(mesh_info, index_of_element, ...
                                      gauss_points, gpsv, m, ...
                                      gamma_alpha, alpha_dir,...
                                      tol)
    if gamma_alpha(1) > 0 && gamma_alpha(1) < 1
        left = fds_on_paths(mesh_info, index_of_element, gauss_points, ...
             gamma_alpha, alpha_dir, tol);
        return
    end
    
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

function left = fds_on_paths(mesh_info, index, gps, alpha, direction, tol)
    num_nodes = size(mesh_info.nodes, 2);
    num_of_gp = size(gps, 2);
    dir = sum(direction);
    left = cell(num_of_gp, 1);
    for i = 1:num_of_gp
        [path, ie, segment] = get_path(mesh_info, index, gps(:, i), ...
                      direction, tol);
        iof = mesh_info.elements(:, ie);
        gp_dir = gps(direction~=0,i);
        v = fd_on_path_v_opt(path, segment, gp_dir, dir, alpha);
        left{i} = sparse(1, iof, v, 1, num_nodes);
    end
    left = cat(1, left{:});
end
