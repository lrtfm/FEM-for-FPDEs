function test2d_inner()
    mesh_ = get_mesh(0.3);
    mesh_info = build_mesh_info(mesh_);
    plot_boundary(mesh_info);

    direction = [1, 0]';
    number = 3;
    plot_some_pathes(mesh_info, direction, number);
    

    test_am(mesh_info, 1);
    test_am(mesh_info, 2);
    test_am(mesh_info, 3);
end

function mesh_ = get_mesh(Hmax)
    % xMin = 0; xMax = 1; yMin = 0; yMax = 1;
    % Area.gd = [ 3; 4; xMin; xMax; xMax; xMin; yMin; yMin; yMax; yMax];
    % Area.ns = char('rect1')';
    % Area.sf = 'rect1';
    a = 1; b = 1; 
    Area.gd = [ 4; 0; 0; a; b; 0];
    Area.ns = char('C1')';
    Area.sf = 'C1';
    [dl,~]=decsg(Area.gd, Area.sf, Area.ns);
    
    if nargin < 1
        Hmax = 0.1;
    end
    [points,~,triangle]=initmesh(dl, 'Hmax', Hmax);

    mesh_.Nodes = points;
    mesh_.Elements = triangle(1:3, :);
end

function myplotmesh(mesh_info)
triplot(mesh_info.elements', mesh_info.nodes(1, :), mesh_info.nodes(2, :));
end

function plot_boundary(mesh_info)
    bn = mesh_info.nodes(:, mesh_info.boundary_flag{1});
    plot(bn(1,:), bn(2, :), 'o'); grid on; hold on;

    be = mesh_info.st{2}(:, mesh_info.boundary_flag{2});
    for i = 1:size(be, 2)
        v = mesh_info.nodes(:, be(:, i));
        plot(v(1, :), v(2, :), 'b-'); hold on;
    end
    title('boundary edge and points');
end

function plot_path(mesh_info, index, gp, path, ie)
    elements = mesh_info.elements;
    nodes = mesh_info.nodes;
    et = nodes(:, elements(:, index));

    myplotmesh(mesh_info); hold on;
    plot(et(1, :), et(2, :), 'v'); hold on;
    plot(gp(1, :), gp(2, :), 'x'); hold on;
    for k = 1:length(ie)
        index_of_nodes = elements(:, ie(k));
        p = path(:, [2*k - 1, 2*k]); % intersection
                                     % point by area coordinate
        seg = nodes(:, index_of_nodes)*p;

        plot(seg(1, :), seg(2, :), '-o'); hold on;
    end
    title('path');
end


function plot_some_pathes(mesh_info, direction, number)
    % direction = [0, 1]';
    tol = 1e-10;
    gso = 1;

    if nargin < 3
        number = 3;
    end

    num_of_elements = size(mesh_info.elements, 2);
    mesh_info = pre_comput_gp_and_index(mesh_info, gso);
    gps = mesh_info.gp;
    ngpe = size(gps{1}, 2);

    Timer = MyTimer(num_of_elements, 100, 'TEST');
    Timer.beginwatch();
    eles = randi([1, num_of_elements], 1, number);
    for index = eles
        for i = 1:ngpe
            gp = gps{index}(:, 1);
            [path, ie, flag] = get_path(mesh_info, index, gp, direction, tol);
            if flag ~= 0
                warning('flag is not zero');
            end
            figure;
            plot_path(mesh_info, index, gp, path, ie);
        end
        Timer = Timer.watch(index);
    end
    Timer.endwatch();
end

%% Test assemble_matrix
function err1 = test_am(mesh_info, gso)
    if nargin < 2
        gso = 3;
    end
    fun = 1;
    alpha = 1;
    beta = 1;
    alpha_dir = [0, 1]';
    beta_dir = -alpha_dir;
    K1 = assemble_matrix_fractional(mesh_info, alpha, alpha_dir, beta, beta_dir, fun, gso);
    K2 = assemble_stiffness_matrix_normal(mesh_info, alpha_dir, fun, gso);
    err1 = max(max(abs(K1+K2)));
    fprintf(1, 'err = %g\n', full(err1));
end



