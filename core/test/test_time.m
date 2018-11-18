function ret = test_time(h)
    if nargin < 1
        h = [0.5, 0.3];
    end
    alpha = 0.9;
    t = zeros(size(h));
    ne = zeros(size(h));
    np = zeros(size(h));
    K = cell(size(h));
    % model = create_cubic_model(r);
    for i = 1:length(h)
        mesh = get_mesh(h(i));
        tstart = tic;
        mesh_info = build_mesh_info(mesh);
        K_alpha = cell(3, 1);
        fprintf(1, 'Mesh h = %g\n', h(i)); 
        for j = 1:3
            direction = zeros(3, 1);
            direction(j) = -1;
            msg = sprintf('\tASM d=[%g, %g, %g]', direction);
            K_alpha{j} = assemble_matrix(mesh_info, alpha, direction,...
                                                    alpha, -direction, 1, 2, msg);
        end
        K{i} = K_alpha{1} +K_alpha{2} + K_alpha{3};
        t(i) = toc(tstart);
        ne(i) = size(mesh.Elements, 2);
        np(i) = size(mesh.Nodes, 2);
    end
    ret = [np(:), ne(:), t(:)];
    head = {'Size', 'Nodes', 'Element', 'Times'};
    ret = table(h(:), ret(:, 1), ret(:, 2), ret(:, 3), 'variablenames', head);
%     Print(1, ret, 'Head', {'Nodes', 'Element', 'Times'}, ...
%         'DataFormat', {'%10g', '%10g', '%10.2f'}, 'OutputFormat', 'Latex')
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