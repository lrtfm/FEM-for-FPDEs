function test3d_inner()
    mesh_st = get_mesh(0.2);
    mesh_info = build_mesh_info(mesh_st);

    test_different_gsp(mesh_info)
    
%     test_fvsn(mesh_info, 1)
%     test_fvsn(mesh_info, 2)
%     test_fvsn(mesh_info, 3)
end

% boundary flag
% bn = mesh_info.nodes(:, mesh_info.boundary_node_flag);
% plot3(bn(1,:), bn(2, :), bn(3, :), '.'); grid on;
% 
% figure
% be = mesh_info.edges(:, mesh_info.boundary_edge_flag);
% for i = 1:size(be, 2)
%     v = mesh_info.nodes(:, be(:, i));
%     plot3(v(1, :), v(2, :), v(3, :), 'b-'); hold on;
% end

function re = re_err(K1_i, K2_i, tol)
    if nargin < 3
        tol = 1e-12;
    end
    ae = abs(K1_i - K2_i);
    nzflag = abs(K1_i) > tol;
    re = ae./abs(K1_i);
    re(~nzflag) = 0;
end

function mesh_st = get_mesh(Hmax)
    if nargin < 1
        Hmax = 0.3;
    end
    r=1;
    [x,y,z] = meshgrid(0:r);
    x = x(:);
    y = y(:);
    z = z(:);
    K = convhull(x,y,z);
    nodes = [x'; y'; z'];
    elements = K';
    model = createpde();
    geometryFromMesh(model, nodes, elements);
    mesh_st = generateMesh(model, 'GeometricOrder', 'linear', 'Hmax', Hmax);
end


% alpha = 0.8;
% alpha_dir = [0, 0, -1]';
% beta = 0.7;
% beta_dir = [0, 0, 1]';
% gso = 2;
% fun = 1;
% % K1 = assemble_stiffness_matrix_normal(mesh_info, alpha_dir, fun, gso);
% K2 = assemble_matrix(mesh_info, alpha, alpha_dir, beta, beta_dir, fun, gso);
% K3 = assemble_matrix_fractional(mesh_info, alpha, alpha_dir, beta, beta_dir, fun, gso);
% 
% errs_max = [err_fun(@max, K2, K3), err_fun(@max, K3, K3)];
% errs_sum = [err_fun(@sum, K2, K3), err_fun(@sum, K3, K3)];
% fprintf(1, 'errors: K2 - K3, K3 - K3\n   max [%g, %g],\n   sum [%g, %g].\n', full(errs_max), full(errs_sum));

%
function test_different_gsp(mesh_info)
    fdf = @(fun, x)full(fun(fun(x)));
    err_fun = @(fun, K1, K2)fdf(fun, abs(K2-K1));
    alpha_dir = [0, 0, -1]';
    beta_dir = [0, 0, 1]';
    alphas = [0,   0, 0, 0.7,   1, 1];
    betas =  [0, 0.8, 1, 0.6, 0.9, 1];
    fun1 = 1;
    for i = 1:length(alphas)

        args1 = { mesh_info, alphas(i), alpha_dir, betas(i), beta_dir, fun1, 2};
        args2 = { mesh_info, alphas(i), alpha_dir, betas(i), beta_dir, fun1, 3};
        K1 = assemble_matrix(args1{:});
        K2 = assemble_matrix(args2{:});
        errs_max = err_fun(@max, K1, K2);
        errs_sum = err_fun(@sum, K1, K2);

        flag = ~mesh_info.boundary_flag{1};
        K1_i = K1(flag, flag);
        K2_i = K2(flag, flag);
        re = re_err(K1_i, K2_i);
        fprintf(1, '[%g, %g]\n', alphas(i), betas(i));
        fprintf(1, '\t errors: max %g, sum %g.\n', full(errs_max), full(errs_sum));
        fprintf(1, '\t re errors: %g%%\n', full(max(max(re)))*100);
        fprintf(1, '\t max(K1-K2)/max(K1): %g%%\n', 100*full(max(max(abs(K1-K2)))/max(max(abs(K1)))));
        fprintf(1, '\t corr2: %g\n', full(corr2(K1,K2)));
        fprintf(1, '-----------------------------------------------------\n');
    end
end

function test_fvsn(mesh_info, gso)
    if nargin < 2
        gso = 3;
    end
    fdf = @(fun, x)full(fun(fun(x)));
    err_fun = @(fun, K1, K2)fdf(fun, abs(K2-K1));
    alpha_dir = [0, 0, -1]';
    beta_dir = [0, 0, 1]';
    alpha = 1;
    beta =  1;
    fun1 = 1;

    args1 = { mesh_info, alpha, alpha_dir, beta, beta_dir, fun1, gso};
    args2 = { mesh_info, beta_dir, fun1, gso};
    K1 = assemble_matrix_fractional(args1{:});
    K2 = assemble_stiffness_matrix_normal(args2{:});
    errs_max = err_fun(@max, K1, K2);
    errs_sum = err_fun(@sum, K1, K2);

    flag = ~mesh_info.boundary_flag{1};
    K1_i = K1(flag, flag);
    K2_i = K2(flag, flag);
    re = re_err(K1_i, K2_i);
    fprintf(1, '[%g, %g]\n', alpha, beta);
    fprintf(1, '\t errors: max %g, sum %g.\n', full(errs_max), full(errs_sum));
    fprintf(1, '\t re errors: %g%%\n', full(max(max(re)))*100);
end

%%
% alpha = 0.9;
% alpha_dir = [0, 0, -1]';
% beta = alpha;
% beta_dir = -alpha_dir;
% args ={ mesh_info3, alpha, alpha_dir, beta, beta_dir };
% K1 = assemble_stiffness_matrix_riesz(args{1:3});
% K2 = assemble_matrix_general(args{:});
% K3 = (K2 + K2')/(2*cos(alpha*pi));
% 
% errs_max = err_fun(@max, K1, K3);
% errs_sum = err_fun(@sum, K1, K3);
% fprintf(1, 'errors: max %g, sum %g.\n', full(errs_max), full(errs_sum));

%% Relative Error of different variational forms of Case 1
% s = 1.8;
% alpha_dir = [0, 0, -1]';
% beta_dir = [0, 0, 1]';
% fun = 1;
% gsn = 4;
% res_max = zeros(1, gsn);
% aes_max = zeros(1, gsn);
% aes_sum = zeros(1, gsn);
% for gso = 1:gsn
%     alpha = 1;
%     beta = s - alpha;
%     args ={ mesh_info3, alpha, alpha_dir, beta, beta_dir, fun, gso };
%     K1 = assemble_matrix_general(args{:});
% 
%     alpha = s/2;
%     beta = alpha;
%     args2 ={ mesh_info3, alpha, alpha_dir, beta, beta_dir, fun, gso };
%     K2 = assemble_matrix_general(args2{:});
% 
%     flag = ~mesh_info3.boundary_node_flag;
%     K1_i = K1(flag, flag);
%     K2_i = K2(flag, flag);
% 
%     aes_max(gso) = fdf(@max, abs(K1_i - K2_i));
%     aes_sum(gso) = fdf(@sum, abs(K1_i - K2_i));
%     re = re_err(K1_i, K2_i);
%     res_max(gso) = fdf(@max, re);
% end
% fprintf(1, 'Relative Error of different variational forms of Case 1\n');
% Print(1, [1:gsn; res_max], 'OutputFormat', 'Plain');

