function M = assemble_mass_matrix(mesh_info, fun, gso)
% assemble_mass_matrix_inner Assemble mass matrix for mesh
% Input: 
%   mesh_info: mesh information output by build_mesh_info
%   fun: Can be any type listed below
%       1. constant
%       2. vector which include value on nodes of mesh
%       3. function handle
%   gso: Order of gauss integral on elements.
% Output:
%   M: Mass matrix with $M_{ij} = (fun\phi_j, \phi_i)$

    if nargin < 3
        gso = 3; % gauss_order
    end
    if nargin < 2
        fun = 1;
    end
    
    elements = mesh_info.elements;
    nodes = mesh_info.nodes;
    number_of_nodes = size(nodes, 2);
    number_of_elements = size(elements, 2);

    m = size(elements, 1);
    M_val = zeros(m*m, number_of_elements);
    [index_col, index_row] = get_index_col_row(mesh_info);
    
    % [gpsv, ~] = get_gauss_points_area_represent(gso);
    [w_all, ~, gpsv, ~] = get_weights_for_integral_on_elements(...
                              mesh_info, fun, gso);
    for i = 1:number_of_elements
        Me = bsxfun(@times, gpsv, w_all(:,i)')*gpsv';
        M_val(:, i) = Me(:);
    end
    M = sparse(index_row(:), index_col(:), M_val(:), ...
               number_of_nodes, number_of_nodes);
end