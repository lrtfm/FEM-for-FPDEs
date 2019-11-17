function model = create_circle_model(r)
    if nargin < 1
        r = 1;
    end
    gm = multisphere(r);
    model = createpde;
    model.Geometry = gm;
    % pdegplot(model,'CellLabels','on','FaceAlpha',0.2);
    % geometryFromMesh(model, nodes, elements);
end