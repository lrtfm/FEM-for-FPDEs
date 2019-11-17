function K = assemble_matrix(mesh_info,...
                             alpha, alpha_dir, beta, beta_dir, fun,...
                             gso, msg, tol)
% assemble_matrix assemble matrix: mass matrix and stiffness matrix.
%    This function compute the inner product 
%               $(fun*D^alpha_{alpha_dir} u, D^beta_{beta_dir} v)$
%    and where alpha_dir and beta_dir are directions of the fractional 
%    derivatives.
%
%       K = assemble_matrix(mesh_info, ...
%                           alpha, alpha_dir, beta, beta_dir)
%
%       K = assemble_matrix(mesh_info, ...
%                           alpha, alpha_dir, beta, beta_dir, fun,...
%                           gso, msg, tol)
%
    if alpha < 0 || alpha > 1 || beta < 0 || beta > 1
        error('assemble_matrix::alpha, beta must be in [0, 1]');
    end
    if nargin < 9
        tol = 10^(-10);
    end
    if nargin < 8
        dir_fmt = get_direction_fmt(alpha_dir);
        fmt = ['(%g:', dir_fmt, ')'];
        fmts = ['AM:', fmt, ', ', fmt];
        msg = sprintf(fmts, alpha, alpha_dir, beta, beta_dir);
    end
    if nargin < 7
        gso = 3;
    end
    if nargin < 6
        fun = 1;
    end
    
    if alpha ==0 && beta == 0
        % msg = [msg '(AMM)' ];
        K = assemble_mass_matrix(mesh_info, fun, gso);
    elseif alpha == 1 && beta == 1
        msg = [msg '(ASMN)'];
        K = assemble_stiffness_matrix_normal(mesh_info, ...
            alpha_dir, fun, gso, msg);
        if get_matrix_correct_flag(alpha, alpha_dir, beta, beta_dir)
            K = -K;
        end
    else
        msg = [msg '(AMF)'];
        K = assemble_matrix_fractional(mesh_info, ...
            alpha, alpha_dir, beta, beta_dir, fun, gso, msg, tol);
    end
end









