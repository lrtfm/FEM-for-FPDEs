function T = get_matrix_template(adj_info, direction)
% GET_MATRIX_TEMPLATE - sparse template for the stiffness matrix
%   According to the adj_info, compute the may be non-zeros element
%   position of the stiffness matrix.

    dir = direction==0;
    nodes = adj_info.nodes(dir, :);
    elements = adj_info.elements;

    nn = size(nodes, 2);

    support_min = zeros(2, nn);
    support_max = zeros(2, nn);
    for i = 1:nn
        e_of_i = adj_info.elements_of_st{1}(:, i);
        e_i = e_of_i(e_of_i(:) ~= 0);
        i_max = max(nodes(:, elements(:, e_i)), [], 2);
        i_min = min(nodes(:, elements(:, e_i)), [], 2);
        support_min(:, i) = i_min; % Need relax the intersection condition?
        support_max(:, i) = i_max;
    end

    index_i = [];
    index_j = [];
    for i = 1:nn
        i_min = support_min(:, i);
        i_max = support_max(:, i);
        flag = i_max < support_min | support_max < i_min;
        flag = flag(1, :) | flag(2, :);
        j_ = find(flag == false)';
        index_i = [index_i; i*ones(length(j_), 1)];
        index_j = [index_j; j_];
    end
    n = length(index_i);
    T = sparse(index_i, index_j, ones(n, 1,'logical'), nn, nn);
end