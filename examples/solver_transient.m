function result = solver_transient(equ, dh, dt, gso)
    % h = 0.1;
    T = equ.T;
    dim = equ.dim;
    real_solution = equ.real_solution;
    source_term = equ.source_term;
    alpha = equ.alpha/2;
    
    mesh_st = equ.get_mesh(dh);
    mesh_info = build_mesh_info(mesh_st);
    inner_node_flag = ~mesh_info.boundary_flag{1};
    
    [K, M] = get_MK(mesh_info, alpha, gso);
    
    K_i = K(inner_node_flag, inner_node_flag);
    M_i = M(inner_node_flag, inner_node_flag);
    % K_r = - K(inner_node_flag, ~inner_node_flag);
    A = M_i - dt/2*K_i;
    B = M + dt/2*K;
    % alpha = max(sum(abs(A),2)./diag(A))-2;
    % L1 = ichol(A, struct('type','ict','droptol',1e-3,'diagcomp',alpha));
    
    x = mat2cell(mesh_info.nodes', size(mesh_info.nodes, 2), ones(dim, 1));
    u0 = real_solution(x, 0);
    un = u0;
    m = floor(T/dt);
    err_max = zeros(m, 1);
    err_L2 = zeros(m, 1);
    err_alpha = zeros(m, 1);
    for i = 1:m
        t = dt*(i - 1/2);
        b = B*un + M*(dt*source_term(x, t));
        % x1 = pcg(A, b(inner_node_flag), 1e-6, 100, L1, L1');
        [x1, flag] = gmres(A, b(inner_node_flag) , 25, 1e-10);
        if flag ~= 0
            warning('gmres return flag is %d\n', flag)
        end
        un(inner_node_flag) = x1;
        ue = real_solution(x, i*dt);
        errs = un-ue;
        err_max(i) = max(abs(errs));
        err_L2(i) = sqrt(abs(errs'*M*errs));
        err_alpha(i) = sqrt(abs(errs'*K*errs));
    end
    
    result.e_max = err_max;
    result.e_L2 = err_L2;
    result.e_alpha = err_alpha;
    result.equ = equ;
    result.mesh_info = mesh_info;
    result.u = un;
    result.u_exact = ue;
    result.x = x;
    result.gso = gso;
    result.dh = dh;
    result.dt = dt;
    % result.errs = errs
end


function [K, M] = get_MK(mesh_info, alpha, gso)
    dim = size(mesh_info.nodes, 1);
    % weight = - h./(2*cos(pi*alpha));
    I = eye(dim);
    K_tmp = cell(dim, 1);
    for i = 1:dim
        direction = I(:, i); 
        K_tmp{i} = assemble_stiffness_matrix_riesz(mesh_info, alpha(i), direction, gso);
    end
    K = fold(@plus, K_tmp);
    M = assemble_mass_matrix(mesh_info, 1, gso);
end