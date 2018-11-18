% TODO
simplex = [0, 0, 0; 1, 0, 0; 0, 1, 0; 0, 0, 1]';
direction = [0, 1/2, 1/2]';
start_point = [0, 0, 0]';

n = size(simplex, 1);
origin = simplex(:, n+1);
A = simplex(:, 1:n) - repmat(origin, 1, n);
A_inv = inv(A);

area_co = get_intersect_point(A_inv, origin, start_point, direction);
p = simplex*area_co;
