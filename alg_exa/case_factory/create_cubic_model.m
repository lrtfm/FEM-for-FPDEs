function model = create_cubic_model(r)
    if nargin < 1
        r = 1;
    end
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