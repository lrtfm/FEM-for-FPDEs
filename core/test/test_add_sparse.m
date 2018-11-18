n = 10;
a = sprand(n, n, 0.1);
Ta = a ~= 0;
m = floor(n/2);
i = unique(randi(n, m, 1));
j = unique(randi(n, m, 1));
b = a;
b(i, j) = 0;
b = sparse(b);
% figure; spy(a); title('a');
% figure; spy(b); title('b');
Tb = b ~= 0;

if Ta - Tb < 0
    error('something is wring!!!');
end
a_full_saved = full(a);
a_saved = sparse(a_full_saved);

add_sparse(a, b);
d = a_saved + b;
flag = full(max(max(d-a)));
if flag == 0
    fprintf(1, 'Test OK!\n');
else
    fprintf(1, 'Test Error! flag = %d\n', flag);
end