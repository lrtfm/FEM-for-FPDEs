function result = steady_sfpde_solver_const(equ, dh, gso, vf)
    if nargin < 4
        vf = 0;
    end

    fun = 1;
    source_term = equ.source_term;
    real_solution = equ.real_solution;
    domain = equ.domain;
    coeff = equ.coeff;

    alpha = equ.alpha/2;
    data_filename = ['sssc-', sprintf('%g-', alpha), sprintf('%g-', dh),...
        sprintf('%g-', gso), equ.msg, '.mat'];
    if exist(data_filename, 'file') == 2 && vf == 0
        load(data_filename, 'mesh_info', 'M', 'K');
    else
        [mesh_info, domain] = get_mesh_info(domain, dh);
        % equ.domain = domain;
        K_alpha_i = cell(3, 1);
        for j = 1:3
            direction = zeros(3, 1);
            direction(j) = -1;
            if vf == 0
                args1 ={ mesh_info, alpha(j), direction, alpha(j), -direction, coeff{j, 1}, gso };
                tmp1 = assemble_matrix(args1{:});
                args2 ={ mesh_info, alpha(j), -direction, alpha(j), direction, coeff{j, 2}, gso };
                tmp2 = assemble_matrix(args2{:});
            else % if vf == 1
                args1 ={ mesh_info, 2*alpha(j)-1, direction, 1, -direction, coeff{j, 1}, gso };
                tmp1 = assemble_matrix(args1{:});
                args2 ={ mesh_info, 2*alpha(j)-1, -direction, 1, direction, coeff{j, 2}, gso };
                tmp2 = assemble_matrix(args2{:});
            end
            K_alpha_i{j} = tmp1 + tmp2;
        end
        K = fold(@plus, K_alpha_i);
        M = assemble_mass_matrix(mesh_info, fun, gso);
        save(data_filename, 'mesh_info', 'M', 'K');
    end
    
    inner_node_flag = ~mesh_info.boundary_flag{1};
    K_i = K(inner_node_flag, inner_node_flag);
    M_i = M(inner_node_flag, inner_node_flag);
    x = {mesh_info.nodes(1, :)', mesh_info.nodes(2, :)', mesh_info.nodes(3, :)'};
    f = source_term(x);
    exact_u = real_solution(x);
    u = exact_u;
    % u(inner_node_flag) = K_i\(M_i*f(inner_node_flag));% gmres(K_i, M_i*f(inner_node_flag));
    u(inner_node_flag) = gmres(K_i, M_i*f(inner_node_flag), 20, 1e-10);
%     show_result(x{:}, u, equ.steps, equ.slices, 'Numerical Solution')
%     show_result(x{:}, exact_u, equ.steps, equ.slices, 'Exact Solution')

    [~, uind, ac] = get_value_on_points(mesh_info, u, equ.watch_points);
    watch_points = equ.watch_points(:, uind(:, 1) ~= 0);
    ac = ac(uind(:, 1) ~= 0, :);
    uind = uind(uind(:, 1) ~= 0, :);
    xwp = mat2cell(watch_points', size(watch_points, 2), ones(3, 1)); 

    wv = sum(ac.*u(uind), 2);
    wv_exact = real_solution(xwp);

    e = exact_u - u;
    result.e_max = max(abs(wv-wv_exact));
    result.e_L2 = sqrt(e' * M * e);
    result.e_L2 = error_norm_l2(real_solution, u, mesh_info);
    result.equ = equ;
    result.dh = dh;
    result.mesh_info = mesh_info;
    result.f = f;   
    result.M = M;
    result.K = K;
    result.u = u;
    result.exact_u = exact_u;
    result.x = x;
    result.gso = gso;
    result.vf = vf;
    result.domain = domain;
end



