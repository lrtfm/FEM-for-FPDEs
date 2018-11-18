function K = assemble_stiffness_matrix_riesz(mesh_info, alpha, direction, gso, msg)
% assemble_stiffness_matrix_riesz assemble the fractional stiffness matrix
%     This function compute the stiffnesss matrix for fractional equations
%     with riesz fractional derivatives, i.e. $(D^alpha_+ u, D^alpha_- v)$,
%     where $0 < alpha <= 1$.
%
%       K = assemble_stiffness_matrix(mesh_info, alpha, direction)
%
    if nargin < 5
        fmt = ['ASMR d = ', get_direction_fmt(direction)];
        msg = sprintf(fmt, direction);
    end
    if nargin < 4
        gso = 4;
    end
    K = assemble_matrix(mesh_info, alpha, direction, alpha, -direction, 1, gso, msg);
    K = -(K + K')/(2*cos(alpha*pi));
end


