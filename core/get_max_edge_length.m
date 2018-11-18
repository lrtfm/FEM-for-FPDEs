function mel = get_max_edge_length(mesh_info)
    elements = mesh_info.elements;
    nodes = mesh_info.nodes;
    edges = mesh_info.st{2};
    edge_of_elements = mesh_info.st_of_elements{2};
    lens = sqrt(sum((nodes(:, edges(1, :)) - nodes(:, edges(2, :))).^2, 1));
    ne = size(elements, 2);
    mel = zeros(ne, 1);
    for i = 1:ne
        mel(i) = max(lens(edge_of_elements(:, i)));
    end
end