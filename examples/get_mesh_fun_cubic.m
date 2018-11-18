function [mesh_fun, range_fun] = get_mesh_fun_cubic(dim, r)
    if nargin < 2
        r = 1;
    end
    if dim == 3
        model = create_model3d_cubic(r);
        mesh_fun = @(h)generateMesh(model, 'GeometricOrder', 'linear', 'Hmax', h);
    elseif dim == 2
        dl = create_model2d_cubic(r);
        mesh_fun = @(h)get_mesh2d_cubic(dl, h);
    else
        error('dim must be in [2, 3]')
    end
    range_fun = @(x)get_x_range_cubic(x, r);
end

function mesh_ = get_mesh2d_cubic(dl, h)
    [points,~,triangle]=initmesh(dl, 'Hmax', h);
    mesh_.Nodes = points;
    mesh_.Elements = triangle(1:3, :);
end

function dl = create_model2d_cubic(r)
    xMin = 0; xMax = r; yMin = 0; yMax = r;
    Area.gd = [ 3; 4; xMin; xMax; xMax; xMin; yMin; yMin; yMax; yMax];
    Area.ns = char('rect1')';
    Area.sf = 'rect1';
    [dl,~]=decsg(Area.gd, Area.sf, Area.ns);
end

function model = create_model3d_cubic(r)
    [x,y,z] = meshgrid(0:r);
    x = x(:);
    y = y(:);
    z = z(:);
    K = convhull(x,y,z);
    nodes = [x'; y'; z'];
    elements = K';
    model = createpde();
    geometryFromMesh(model, nodes, elements);
end

function range = get_x_range_cubic(x, r)
	n = length(x);
	range = repmat({0, r}, n, 1);
end