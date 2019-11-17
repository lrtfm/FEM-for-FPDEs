function mesh_st = create_mesh(x_range, m)
    h = (x_range(:, 2) - x_range(:, 1))./m;
    n = size(x_range, 1);
    x = cell(1, n);
    for i = 1:n
        x{i} = x_range(i, 1):h(i):x_range(i, 2);
    end
    X = meshgrid_inner(x);
    if length(m) == 1
        m = repmat(m, n, 1);
    end
    base_x = m(1) + 1;
    base_y = m(2) + 1;
    base_z = base_x * base_y;
    number = 6;
    elements = zeros(4, number*fold(@times, m));
    for k = 1:m(3)
        base1 = base_z*(k-1);
        s = (k-1)*m(1)*m(2);
        for i = 1:m(1)
            base2 = base1 + base_y*(i-1);
            ss = s + (i-1)*m(1);
            for j = 1:m(2)
                base_index = base2 + j;
                tmp = [base_index; base_index + base_y; 
                         base_index + base_y + 1;  base_index + 1];
                index = [tmp; tmp + base_z];
                tet = cube2tet(index);
                c = (ss + j -1)*number + 1;
                elements(:, c:c+number-1) = tet;
            end
        end
    end
    mesh_st.Nodes = X';
    mesh_st.Elements = elements;
end

function tet = cube2tet(index)
    A = [1, 2, 3, 7; 1, 2, 6, 7; 1, 5, 6, 7; ...
         1, 3, 4, 7; 1, 4, 7, 8; 1, 5, 7, 8;]';
    tet = index(A);
end

function X = meshgrid_inner(x)
    n = length(x);
    if n == 3
        [X1, X2, X3] = meshgrid(x{:});
        X = [X1(:), X2(:), X3(:)];
    elseif n == 2
        [X1, X2] = meshgrid(x{:});
        X = [X1(:), X2(:)];
    else
        error('meshgrid_inner:error n must be 2 or 3!');
    end
end