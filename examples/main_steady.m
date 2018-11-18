% steady example

% prepare equation parameter
dim = 2;
alpha = repmat(1.8, dim, 1);
c_s = ones(dim, 1);
p = repmat([2, 2], dim, 1);
equ = build_examples_cubic_steady(dim, alpha, c_s, p);

% get mesh
dhs = [8, 16, 32];
len = length(dhs);
result = cell(len, 1);
for i = 1:len
    dh = 1/dhs(i);
    mesh_st = equ.get_mesh(dh);

    % assemble mass and stiffness matrices
    st = tic;
    mesh_info = build_mesh_info(mesh_st);
    gso = 3;
    I = eye(dim);
    K_tmp = cell(dim, 1);
    for j = 1:dim
        direction = I(:, j); 
        K_tmp{j} = assemble_stiffness_matrix_riesz(mesh_info, alpha(j)/2, direction, gso);
    end
    K = fold(@plus, K_tmp);
    usedtime = toc(st);
    fprintf(1, '----------------------------XYZ ASMR used time: %s\n', ...
        calendarDuration(0, 0, 0, 0, 0, usedtime));
    M = assemble_mass_matrix(mesh_info, 1, gso);

    inner_node_flag = ~mesh_info.boundary_flag{1};
    K_i = - K(inner_node_flag, inner_node_flag); % because equ is -Lu = f.
    M_i = M(inner_node_flag, inner_node_flag);

    x = mat2cell(mesh_info.nodes', size(mesh_info.nodes, 2), ones(dim, 1));
    f = equ.source_term(x);
    u_exact = equ.real_solution(x);
    u = u_exact;
    A = K_i;
    b = M_i*f(inner_node_flag);
    stse = tic;
    [x1, flag] = gmres(A, b, 25, 1e-6);
    gmrestime = toc(stse);
    fprintf(1, ['---------------------------GMRES used time: ' num2str(gmrestime) 's\n']);

    if flag ~= 0
        warning('flag is %d\n', flag);
    end
    u(inner_node_flag) = x1;
    tmp_result.mesh_info = mesh_info;
    tmp_result.u = u;
    tmp_result.u_exact = u_exact;
    tmp_result.dh = dh;
    tmp_result.A = A;
    tmp_result.b = b;
    errs = u - u_exact;
    tmp_result.e_max = max(abs(errs));
    tmp_result.e_L2 = sqrt(abs(errs'*M*errs));
    tmp_result.e_alpha = sqrt(abs(errs'*K*errs));
    % save result to a struct
    se_results.(['result' int2str(dhs(i))]) = tmp_result;
    % show results
    result{i} = tmp_result;
    show_numerical_results(tmp_result);
end
print_results_order(result);
