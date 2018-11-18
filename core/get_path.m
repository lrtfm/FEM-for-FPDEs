function [path, ie, segment] = get_path(mesh_info, index, gp, ...
                                        direction, tol)
    % fprintf(1, '\tgauss points i = %d begin ...\n', i);
    dim = size(mesh_info.nodes, 1);
    mesh_info.stoe = mesh_info.st_of_elements{dim}; % face
    mesh_info.eost = mesh_info.elements_of_st{dim};
    [path, ie, flag, segment] = get_path_inner(mesh_info, index, gp, direction, tol);
    its = 1;
    while flag > 0 && its < 6
        warning('index:%d, tol:%d, redo!\n', index, tol*10^its);
        [path, ie, flag, segment] = get_path_inner(mesh_info, index, gp, direction, tol*10^its);
        its = its + 1;
    end
    if its == 6
        if flag == 1
            msg = 'get_path::stop not on the boundary!';
        elseif flag == 2
            msg = 'get_path::volume coordinate all non-zeros!';
        else
            msg = 'what???';
        end
        error('%s index = %d', msg, index);
    end
    % fprintf(1, '\t get path for i = %d ok!\n', i);
end

function [path, intersect_elements, flag, segment] = get_path_inner(...
                             mesh_info, index, gp, direction, tol)
% GET_PATH - get integral path start from `gp` with `direction`
%   According to the mesh_info, compute the integral path.
    flag = 0;
    edge_table = [ 0, 1, 2, 3; 1, 0, 4, 5; 2, 4, 0, 6; 3, 5, 6, 0];
    pre = [1, 2, 6];
    
    elements = mesh_info.elements;
    nodes = mesh_info.nodes;
    dim = size(nodes, 1);
    max_allocate_index = floor(...
        nthroot(pre(dim)^(dim-1) * size(elements, 2), dim));
    intersect_elements = zeros(1, max_allocate_index);
    path = zeros(dim+1, 2*max_allocate_index);
    segment = zeros(1, 2*max_allocate_index);
    number_of_segments = 0;
    dirflag = direction ~= 0;
    
    k_max = 0;
    tmpv = zeros(dim+1, 1);
    tmpp = zeros(dim+1, 2);
    while index
        % fprintf(1, '\t\t\t\tbegin start = %d, index = %d\n', start, index)
        ep = nodes(:, elements(:, index));
        A_inv = mesh_info.A_inv{index};
        % [p, r] = get_intersect_point_mex(A_inv, ep(:, dim+1), gp, direction, tol);
        [p, r] = get_intersect_point(A_inv, ep(:, dim+1), gp, direction, tmpv, tmpp, tol);
        
        if isempty(p) || r <= k_max %  condition (k <= k_max) fixed
                                  %  for infinit loop in two tri if
                                  %  the line is almost parallel.
            current = current + 1;
            if current <= length(some_new_index)
                index = some_new_index(current);
                continue
            end
            % warning('get_path::will be right? index = %d', index);
            % direction
            break
        end
        k_max = r;
        if size(p, 2) ~= 2
            error('get_path::p must be (dim+1)x2!!!');
        end
        number_of_segments = number_of_segments + 1;
        if number_of_segments > max_allocate_index
            new_allocate = 100;
            max_allocate_index = max_allocate_index + new_allocate;
            path = [path, zeros(dim+1, new_allocate*2)];
            intersect_elements = [intersect_elements, zeros(1, ...
                                                            new_allocate)];
            segment = [segment, zeros(1, 2*new_allocate)];
        end
        double_nos = 2*number_of_segments;
        path(:, double_nos - 1:double_nos) = p;
        segment(:, double_nos - 1:double_nos) = ep(dirflag, :) * p;
        intersect_elements(:, number_of_segments) = index;
        k = p(:, 2) <= tol;

        if dim == 3
            n = k(1) + k(2) + k(3) + k(4); %         n = sum(k);
            if n == 1
                what = mesh_info.stoe(k, index); % face
                e = mesh_info.eost(:, what);
                some_new_index = e(e ~= index);
            elseif n == 2
                tmp = edge_table(k==0, k==0);
                what = mesh_info.st_of_elements{2}(tmp(1, 2), index); % edge
                e = mesh_info.elements_of_st{2}(:, what);
                some_new_index = e(e ~= index);
            elseif n == 3
                what = mesh_info.elements(k==0, index); % point
                e = mesh_info.elements_of_st{1}(:, what);
                some_new_index = e(e ~= index);
            else % n == 0
                flag = 2;
                return
                % error('get_path::some thing is wrong here! n = %d', n);
            end
        elseif dim == 2
            n = k(1) + k(2) + k(3);
            if n == 1
                what = mesh_info.stoe(k, index); 
                e = mesh_info.eost(:, what);
                some_new_index = e(e ~= index);
            elseif n == 2
                what = elements(k==0, index); % point
                e = mesh_info.elements_of_st{1}(:, what);
                some_new_index = e(e ~= index);
            else % n == 0
                flag = 2;
                return
                % error('get_path::some thing is wrong here! n = %d', n);
            end
        elseif dim == 1
            n = k(1) + k(2);
            if n == 1
                what = elements(k==0, index); % point
                e = mesh_info.elements_of_st{1}(:, what);
                some_new_index = e(e ~= index);
            else % n == 0
                flag = 2;
                return
                % error('get_path::some thing is wrong here! n = %d', n);
            end
        else
            error('dim must be in [1, 2, 3]');
        end
        
        if isempty(some_new_index)
            break;
        end

        current = 1;
        index = some_new_index(current);
    end
    path = path(:, 1:number_of_segments*2);
    intersect_elements = intersect_elements(1:number_of_segments);
    segment = segment(:, 1:number_of_segments*2);
    
    if flag ~=2 && ~is_on_the_boundary(mesh_info, dim, n, what)
        flag = 1; % error('get_path::stop not on the boundary! n = %d', n);
    end
    % fprintf('\t\t\tnumber of seg %d\n', number_of_segments);
end

function b = is_on_the_boundary(mesh_info, dim, n, what)
    b = mesh_info.boundary_flag{dim+1-n}(what);
end
