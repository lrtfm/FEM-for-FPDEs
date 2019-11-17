function mesh_info = build_mesh_info(mesh)
% BUILD_MESH_INFO build the mesh infomation from parameter `mesh`, which
%     is a struct containing the Nodes and Elements.

    Timer = MyTimer(1, 1, 'BUILD_MESH_INFO');
    Timer.beginwatch();
    nodes = mesh.Nodes;
    elements = mesh.Elements;
    dim = size(nodes, 1);
    sort_elements = sort(elements, 1, 'ascend');

    % may be build automaticly.
    [nspe_table, siie_table, fe_table,  pat] = get_something(dim);
    
    st = cell(dim, 1);
    st_of_elements = cell(dim, 1);
    elements_of_st = cell(dim, 1);
    for i = 1:dim
        [st{i}, st_of_elements{i}] = get_mesh_info_of_st(sort_elements,...
                                               i, nspe_table, siie_table);
        elements_of_st{i} = get_elements_of_st(i, size(st{i}, 2), ...
                                               st_of_elements{i}, ...
                                               nspe_table, pat);
    end

%     elements_of_points = get_elements_of_st(1, size(nodes, 2), ...
%                                            sort_elements, ...
%                                            nspe_table, pat);

    mesh_info.elements = sort_elements;
    mesh_info.nodes = nodes;
    
    mesh_info.st = st;
    mesh_info.st_of_elements = st_of_elements;
    mesh_info.elements_of_st = elements_of_st;

    boundary_flag = get_boundary_flag(mesh_info, fe_table);

    mesh_info.boundary_flag =boundary_flag;
    
    [A_inv, vols] = get_inv_A_and_vol(nodes, sort_elements);
    mesh_info.A_inv = A_inv;
    mesh_info.vols = vols;
    mesh_info.dim = dim;
    Timer.endwatch();
end

function [nspe_table, siie_table, fe_table, pat] = get_something(dim)
    if dim == 3
        nspe_table = [4, 6, 4];
        siie_table = {[1, 2, 3, 4], ...
                      [1, 2; 1, 3; 1, 4; 2, 3; 2, 4; 3, 4]', ...
                      [2, 3, 4; 1, 3, 4; 1, 2, 4; 1, 2, 3]'};
        fe_table = [4, 5, 6; 2, 3, 6; 1, 3, 5; 1, 2, 4]';
        pat = [20, 8, 2];
    elseif dim == 2
        nspe_table = [3, 3];
        siie_table = {[1, 2, 3], [2, 3; 1, 3; 1, 2]'};
        fe_table = [];
        pat = [10, 2];
    elseif dim == 1
        nspe_table = 2;
        siie_table = {[1, 2]};
        fe_table = [];
        pat = 2;
    else
        error('dim must be in [1, 2, 3]')
    end
end

function [A_inv, vol] = get_inv_A_and_vol(nodes, elements)
% GET_INV_A_AND_VOL - get the inverse of local element axis.

    ne = size(elements, 2);
    A_inv = cell(ne, 1);
    vol = zeros(ne, 1);
    dim = size(nodes, 1);
    coeff = [1, 2, 6]; % for different dimension
    for i = 1:ne
        e = nodes(:, elements(:, i));
        % A = [e(:, 1) - e(:, 4), e(:, 2) - e(:, 4), ...
        %      e(:, 3) - e(:, 4)];
        A = e(:, 1:dim) - e(:, dim+1);
        A_inv{i} = inv(A);
        vol(i) = abs(det(A));
    end
    vol = vol/coeff(dim);
end

function elements_of_st = get_elements_of_st(n, number_of_st, ...
                                             st_of_elements, ...
                                             nspe_table, pa_table)
    number_of_elements = size(st_of_elements, 2);
    k = nspe_table(n);
    max_index = pa_table(n);
    elements_of_st = zeros(max_index, number_of_st);
    les = zeros(1, number_of_st);
    for i = 1:number_of_elements
        for j = 1:k
            index = st_of_elements(j, i);
            les(index) = les(index) + 1;
            if les(index) > max_index
                elements_of_st = [elements_of_st; zeros(1, ...
                                                        number_of_st)];
                max_index = max_index + 1;
            end
            elements_of_st(les(index), index) = i;
        end
    end
    real_max_index = max(les);
    elements_of_st = elements_of_st(1:real_max_index, :);
end

function [st, st_of_elements] = get_mesh_info_of_st(elements, n, nspe_table, siie_table)
% n        : face (3) or edge (2)
% elements : sort elements

    number_of_st_per_element = nspe_table(n);
    st_index_in_element = siie_table{n};

    number_of_elements = size(elements, 2);
    all_st1 = elements(st_index_in_element, :);
    all_st = reshape(all_st1(:), n, number_of_st_per_element*number_of_elements)';
    [unique_st, ~, ic] = unique(all_st, 'rows');
    st_of_elements = reshape(ic, number_of_st_per_element, number_of_elements);
    st = unique_st';
end

function boundary_flag = get_boundary_flag(mesh_info, fe_table)
% output:
%    boundary_flag{3} - boundary_face_flag;
%    boundary_flag{2} - boundary_edge_flag;
%    boundary_flag{1} - boundary_node_flag;
    dim = size(mesh_info.nodes, 1);
    boundary_flag = cell(dim, 1);
    
    boundary_flag{dim} = mesh_info.elements_of_st{dim}(2,:) == 0;
    boundary_node = unique(mesh_info.st{dim}(:, boundary_flag{dim}));
    boundary_flag{1} = zeros(1, size(mesh_info.nodes, 2), 'logical');
    boundary_flag{1}(boundary_node) = true;
    
    if dim == 3
        bff = boundary_flag{dim};

        boundary_flag{2} = zeros(1, size(mesh_info.st{2}, 2), 'logical');
        boundary_face = find(bff);
        for  i = boundary_face
            e = mesh_info.elements_of_st{3}(1, i);
            local_face_index = mesh_info.st_of_elements{3}(:, e) == i;
            local_edge_index = fe_table(:, local_face_index);
            index_of_edge = mesh_info.st_of_elements{2}(local_edge_index, e);
            boundary_flag{2}(index_of_edge) = true;
        end
    end
end