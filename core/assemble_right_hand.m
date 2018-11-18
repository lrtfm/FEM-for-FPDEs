function b = assemble_right_hand(mesh_info, fun)
%  get_fun_dot_base compute the vector with elements (fun, phi_i)
%      where fun is the function value on nodes.

    go = 1; % gauss_order
    elements = mesh_info.elements;
    nodes = mesh_info.nodes;
    [dim, number_of_nodes] = size(nodes);
    number_of_elements = size(elements, 2);

    [gps, w] = get_gauss_points_area_represent(dim, go);
    w = w(:);
    b = zeros(number_of_nodes, 1);
    for i = 1:number_of_elements
        indeice = elements(:, i);
        area = mesh_info.vols(i);
        f_on_gps = gps' * fun(indeice);
        be = gps * (area * w .* f_on_gps);
        b(indeice) = b(indeice) + be;
    end
end