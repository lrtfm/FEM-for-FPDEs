function [index_col, index_row] = get_index_col_row(mesh_info)
    if isfield(mesh_info, 'index_col') && isfield(mesh_info, 'index_row')
        index_col = mesh_info.index_col;
        index_row = mesh_info.index_row;
        return
    end
    
    elements = mesh_info.elements;
    [m, number_of_elements] = size(elements);
    index_col = zeros(m*m, number_of_elements);
    index_row = zeros(m*m, number_of_elements);
    for i = 1:number_of_elements
        indeice = elements(:, i);
        index_row(:, i) = repmat(indeice, m, 1);
        index_col(:, i) = kron(indeice, ones(m, 1));
    end
end