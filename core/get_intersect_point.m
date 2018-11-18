function [p, k0_max] = get_intersect_point(A_inv, origin, start_point, ...
                                           direction, tmp_v, tmp_p, tol)
% GET_INTERSECT_POINT Get intersection segment of ray and n-D simplex.
% input: A_inv, origin, start_point, direction.
%    % A = [element(:, 1) - element(:, n+1), ...
%    %      element(:, 2) - element(:, n+1), ...
%    %           ...               ...
%    %      element(:, n) - element(:, n+1)]^(-1);
%    tmp_v = zeros(n+1,1); tmp_p = zeros(n+1,2); % add tmp to reduce time.
    n = size(A_inv, 1);
    len = n + 1;
    if nargin < 7
        tol = 10^(-12);  % Is it suitable?
        if nargin < 5
            tmp_v = zeros(len, 1); tmp_p = zeros(len, 2);
        end
    end

    v1 = tmp_v; v2 = v1; 
    vect = start_point - origin;
    if n == 3
        v1(1) = A_inv(1, 1)*vect(1) + A_inv(1, 2)*vect(2) + A_inv(1, 3)*vect(3);
        v1(2) = A_inv(2, 1)*vect(1) + A_inv(2, 2)*vect(2) + A_inv(2, 3)*vect(3);
        v1(3) = A_inv(3, 1)*vect(1) + A_inv(3, 2)*vect(2) + A_inv(3, 3)*vect(3);
        v2(1) = A_inv(1, 1)*direction(1) + A_inv(1, 2)*direction(2) + A_inv(1, 3)*direction(3);
        v2(2) = A_inv(2, 1)*direction(1) + A_inv(2, 2)*direction(2) + A_inv(2, 3)*direction(3);
        v2(3) = A_inv(3, 1)*direction(1) + A_inv(3, 2)*direction(2) + A_inv(3, 3)*direction(3);
        v1(len) = 1 - (v1(1) + v1(2) + v1(3));
        v2(len) = - (v2(1) + v2(2) + v2(3));
    elseif n == 2
        v1(1) = A_inv(1, 1)*vect(1) + A_inv(1, 2)*vect(2);
        v1(2) = A_inv(2, 1)*vect(1) + A_inv(2, 2)*vect(2);
        v2(1) = A_inv(1, 1)*direction(1) + A_inv(1, 2)*direction(2);
        v2(2) = A_inv(2, 1)*direction(1) + A_inv(2, 2)*direction(2);
        v1(len) = 1 - (v1(1) + v1(2));
        v2(len) = - (v2(1) + v2(2));
    else
        v1(1:n) = A_inv * vect;
        v2(1:n) = A_inv * direction;
        v1(len) = 1 - sum(v1(1:n));
        v2(len) = - sum(v2(1:n));
    end

    k0 = - v1./v2;
    k0_min = 0;
    k0_max = 999; % Should be setted be the diameter of the domain.

    for i = 1:len
        if v2(i) < -tol
            if k0(i) < k0_max
                k0_max = k0(i);
            end
        elseif v2(i) > tol
            if k0(i) > k0_min
                k0_min = k0(i);
            end
        else
            if v1(i) < -tol
                p = zeros(len, 0);
                return
            end
        end
    end

%     if (abs(k0_max - k0_min) < tol)
%         warning('get_intersect_poin::min and max k0 is close %f!!!', ...
%                 k0_max - k0_min);
%         p = zeros(4, 0);
%         return
%     end
    if k0_max > k0_min
        p = tmp_p;
        p(:, 1) = v1 + v2*k0_min;
        p(:, 2) = v1 + v2*k0_max;
        % p(p <= tol) = 0; % p( abs(p) < tol ) = 0;
    else
        p = zeros(len, 0);
    end
end
