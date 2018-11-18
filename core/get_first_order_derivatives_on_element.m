function df = get_first_order_derivatives_on_element(...
                mesh_info, index_of_element, direction)
% get_first_order_derivatives_on_element Get the first order derivative 
% on element
% Input: 
%   direction: must be direction parallel with axis
% Outpu:
%   df: derivative value for each basis function on element.

    indeice = mesh_info.elements(:, index_of_element);
    et = mesh_info.nodes(:, indeice);
    npe = size(et, 2); % number of points per element
    p_ = get_intersect_point(mesh_info.A_inv{index_of_element}, ...
                             et(:, npe), sum(et, 2)/npe, direction);
    p = et*p_;
    dir_flag = direction ~= 0;
    inter = p(dir_flag, 2) - p(dir_flag, 1);
    df = (p_(:, 2) - p_(:, 1))/inter;
end