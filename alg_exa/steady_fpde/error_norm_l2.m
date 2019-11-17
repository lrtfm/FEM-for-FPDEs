function s = error_norm_l2(u_handle, u, mesh_info, fun, gso)
% comput error in L2 norm

    if nargin < 5
        gso = 4; % gauss_order
    end
    if nargin < 4
        fun = 1;
    end
    
    elements = mesh_info.elements;
    number_of_elements = size(elements, 2);
    
    % [gpsv, ~] = get_gauss_points_area_represent(gso);
    [w_all, gps, gpsv, ~] = get_weights_for_integral_on_elements(...
                              mesh_info, fun, gso);
    s = 0;
    for i = 1:number_of_elements
        gp = gps{i};
        x = mat2cell(gp, ones(1, size(gp, 1)), size(gp, 2));
        err = (u_handle(x)' - gpsv'*u(elements(:, i))).^2;
        s = s + w_all(:, i)'*err;
    end
    s = sqrt(s);
end