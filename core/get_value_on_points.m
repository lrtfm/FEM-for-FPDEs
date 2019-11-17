function [v, uind, ac] = get_value_on_points(mesh, u, p)
% Input:
%   - mesh: a struct of nodes and elements
%   - u: values on nodes (vector)
%   - p: points (dim*np matrix)
% Output:
%   - v: value on points (p)

    if isfield(mesh, 'Elements')
        elements = mesh.Elements;
    elseif isfield(mesh, 'elements')
        elements = mesh.elements;
    else
        error('XXXXXXXXXXXX');
    end

    if isfield(mesh, 'Nodes')
        nodes = mesh.Nodes;
    elseif isfield(mesh, 'nodes')
        nodes = mesh.nodes;
    else
        error('XXXXXXXXXXXX');
    end
    tol = 1e-12;
    p = p';
    dim = size(nodes, 1);
    ne = size(elements, 2);
    np = size(p, 1);
    v = zeros(np, 1);
    uind = zeros(np, dim+1);
    ac = zeros(np, dim+1);
    for i = 1:ne
        nodes_of_e = nodes(:, elements(:, i))';
        bound_min = min(nodes_of_e);
        bound_max = max(nodes_of_e);
        ind = sum(p >= bound_min - tol & p <= bound_max + tol, 2) == dim;
        p2 = p(ind, :);
        if isempty(p2)
            continue
        end
        np2 = size(p2, 1);

        value = zeros(np2, dim+1);
        for j = 1:np2
            tmp = [nodes_of_e, ones(dim+1, 1)];
            a = det(tmp);
            b = p2(j, :);
            if dim == 2
                value(j, 1) = get_volume(1, b, tmp)/a;
                value(j, 2) = get_volume(2, b, tmp)/a;
                value(j, 3) = get_volume(3, b, tmp)/a;
            elseif dim == 3
                value(j, 1) = get_volume(1, b, tmp)/a;
                value(j, 2) = get_volume(2, b, tmp)/a;
                value(j, 3) = get_volume(3, b, tmp)/a;
                value(j, 4) = get_volume(4, b, tmp)/a;
            else
                error('dim must be 2 or 3');
            end
    %         for k = 1:dim+1
    %             value(j, k) = get_volume(k, b, tmp)/a;
    %         end
        end
        index2 = sum(value >= -tol, 2) == dim+1 | sum(value <= tol, 2) == dim+1;
        ind(ind) = index2;
        v(ind) = value(index2, :)* u(elements(:, i));
        uind(ind, :) = repmat(elements(:, i)', sum(index2), 1);
        ac(ind, :) = value(index2, :);
    end
end

function ret = get_volume(i, b, tmp)
    tmp(i, 1:length(b)) = b;
    ret = det(tmp);
end