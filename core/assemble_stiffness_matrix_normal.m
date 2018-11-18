function K = assemble_stiffness_matrix_normal(mesh_info, ...
                                                    direction, fun,...
                                                    gso, msg)
% assemble_stiffness_matrix_normal_inner assemble normal stiffness matrix
%    This function compute the inner product 
%               $(fun*D u, D v)$
%
%       K = assemble_stiffness_matrix_normal(mesh_info, dirction, fun,...
%                                            gso, msg, tol)
    if nargin < 5
        fmt = get_direction_fmt(direction);
        msg = ['ASMN:' sprintf(fmt, direction) ];
    end
    elements = mesh_info.elements;
    nodes = mesh_info.nodes;
    number_of_nodes = size(nodes, 2);
    number_of_elements = size(elements, 2);

    m = size(elements, 1);
    K_val = zeros(m*m, number_of_elements);

    [index_col, index_row] = get_index_col_row(mesh_info);
    w_all = get_weights_for_integral_on_elements(mesh_info, fun, gso);
    
    Timer = MyTimer(number_of_elements, 500, msg);
    Timer.beginwatch();
    for i = 1:number_of_elements
        df = get_first_order_derivatives_on_element(mesh_info, i, direction);
        Ke = (sum(w_all(:,i))*df)*df';
        K_val(:, i) = Ke(:);
        Timer.watch(i);
    end
    K = sparse(index_row(:), index_col(:), K_val(:), number_of_nodes, number_of_nodes);
    Timer.endwatch();
end