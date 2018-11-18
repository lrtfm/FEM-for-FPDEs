% Create a ball in $R^3$ with r = 0.5
r = 0.5;
model = createpde;
model.Geometry = multisphere(r);
dim = 3; % Dimension of $\varOmega$.

alpha = repmat(1.8, dim, 1); % $\alpha$
source_term = @(x)x{1}.^2+x{2}.^2+x{3}.^2 - 0.25; % $f(\mathbf{x})$

h = 1/16;
mesh_ = generateMesh(model, 'GeometricOrder', 'linear', 'Hmax', h);
mesh_info = build_mesh_info(mesh_);  % build the mesh_info

% Begin assemble stiffness matrix for riesze fractional derivatives
gso = 3;
I = eye(dim);
K_tmp = cell(dim, 1);
for j = 1:dim
    direction = I(:, j); 
    K_tmp{j} = assemble_stiffness_matrix_riesz(mesh_info, alpha(j)/2, direction, gso);
end
K = fold(@plus, K_tmp);
% End

% Assemble mass matrix
M = assemble_mass_matrix(mesh_info, 1, gso);

% Delete the column and row of boundary nodes.
inner_node_flag = ~mesh_info.boundary_flag{1};
K_i = - K(inner_node_flag, inner_node_flag); % because equ is -Lu = f.
M_i = M(inner_node_flag, inner_node_flag);

% Compute the right hand value, i.e. $f(\mathbf{x})$.
x = mat2cell(mesh_info.nodes', size(mesh_info.nodes, 2), ones(dim, 1));
f = source_term(x);

% Solve linear equation.
A = K_i;
b = M_i*f(inner_node_flag);
[x1, flag] = gmres(A, b, 25, 1e-6);