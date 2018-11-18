function [gps, ws, gp, w, npe] = get_all_gauss_points(mesh_info, gso)
    dim = size(mesh_info.nodes, 1);
    [gp, w, npe] = get_gauss_points_area_represent(dim, gso);    
    if isfield(mesh_info, 'gp') && isfield(mesh_info, 'w')
        gps = mesh_info.gp;
        ws = mesh_info.w;
        return
    end
    
    elements = mesh_info.elements;
    nodes = mesh_info.nodes;
    vols = mesh_info.vols;
    [~, number_of_elements] = size(elements);
    gps = cell(number_of_elements, 1);
    ws = cell(number_of_elements, 1);
    
    for i = 1:number_of_elements
        indeice = elements(:, i);
        gps{i} = nodes(:, indeice)*gp;
        ws{i} = vols(i)*w;
    end
end