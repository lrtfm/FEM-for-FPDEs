function [w, gps, gp, n] = get_weights_for_integral_on_elements(mesh_info, fun, gso)
% get_weights_for_integral_on_elements Assemble mass matrix for mesh
% Input: 
%   mesh_info: mesh information output by build_mesh_info
%   fun: Can be any type listed below
%       1. constant
%       2. vector which include value on nodes of mesh
%       3. function handle
%   gso: Order of gauss integral on elements.
% Output:
%   w: Matrix of weights: $num_of_gp_per_element \times num_of_elements$.
%       Each element takes one column in w.
%   gps: cell matrix: $num_of_elements \times 1$.
%       gaussian point for every element.
%   gp: gaussian point by area represent on one element
%   n: number of gaussian points per element

    elements = mesh_info.elements;
    number_of_nodes = size(mesh_info.nodes, 2);
    
    [gps, ws, gp, gw, n] = get_all_gauss_points(mesh_info, gso);
    % values on nodes
    if isa(fun, 'numeric') && length(fun) == number_of_nodes
        % [gpsv, gwv, ~] = get_gauss_points_area_represent(gso);
        vols = mesh_info.vols';
        f = bsxfun(@times, fun(elements), vols); % fun*area
        fgp = gp'*f;
        w = fgp.*gw';
        return
    end

	% fun is a function handle
    if isa(fun, 'function_handle')
        f = cellfun(fun, gps, 'UniformOutput',false);   % fun: $M_{D \times n} -> v_{1 \times n}$
        w = cell2mat(f).*cell2mat(ws);
        w = w';
        % for i = 1:number_of_elements
        %     % fv = fun(gps{i});
        %     w(:, i) = fun(gps{i}).*ws{i};
        % end
        return
    end
    
    % constant value of fun
    if isa(fun, 'numeric') && length(fun) == 1
        w = fun*cell2mat(ws)';
        % for i = 1:number_of_elements
        %     w(:, i) = fun.*ws{i};
        % end
        return
    end

    error('get_all_weight:error type of fun');
end


