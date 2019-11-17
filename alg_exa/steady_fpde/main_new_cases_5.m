
clear
disp 'test steady fpde variable left and right'
gso = 2;
dh = [1/8, 1/16, 1/32];

% coeff.fun = {@(x)ones(1, size(x, 2)), @(x)-ones(1, size(x, 2)); 
%              @(x)ones(1, size(x, 2)),@(x)-ones(1, size(x, 2));
%              @(x)ones(1, size(x, 2)),@(x)-ones(1, size(x, 2))};
% coeff.df = {@(x)zeros(1, size(x, 2)), @(x)zeros(1, size(x, 2)); 
%              @(x)zeros(1, size(x, 2)),@(x)zeros(1, size(x, 2));
%              @(x)zeros(1, size(x, 2)),@(x)zeros(1, size(x, 2))};
coeff.fun = {@(x)x(1, :), @(x)(-1+x(1, :)); 
             @(x)x(2, :), @(x)(-1+x(2, :));
             @(x)x(3, :), @(x)(-1+x(3, :));};
coeff.df = {@(x)ones(1, size(x, 2)), @(x)ones(1, size(x, 2));
            @(x)ones(1, size(x, 2)), @(x)ones(1, size(x, 2));
            @(x)ones(1, size(x, 2)), @(x)ones(1, size(x, 2))};
alpha = repmat(1.8, 3, 1);
p = repmat([2, 2], 3, 1);

msg = 'tsfs5_x_1_s';
equ = steady_fpde_case(alpha, p, coeff);
result = arrayfun(@(h)steady_sfpde_solver(equ, h, gso), dh ,'UniformOutput',false);
post_steady_result(result, msg);
save(msg);

alpha = [1.6, 1.7, 1.8]'; % repmat(1.8, 3, 1);
p = repmat([2, 2], 3, 1);

msg = 'tsfs5_x_1_n';
equ = steady_fpde_case(alpha, p, coeff);
result = arrayfun(@(h)steady_sfpde_solver(equ, h, gso), dh ,'UniformOutput',false);
post_steady_result(result, msg);
save(msg);

% % % % new_cases_5
% % % % test steady fpde variable left and right
% % % % BUILD_MESH_INFO Begin(1).End. Used time: 0h 0m 0.063726s
% % % % Starting parallel pool (parpool) using the 'local' profile ...
% % % % connected to 4 workers.
% % % % Lab 1: 
% % % %   AM:(0.8:([-1 ,0 ,0])), (1:([1 ,-0 ,-0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 5.1772s
% % % % Lab 1: 
% % % %   AM:(0.8:([1 ,-0 ,-0])), (1:([-1 ,0 ,0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 2.8355s
% % % % Lab 1: 
% % % %   AM:(0.8:([0 ,-1 ,0])), (1:([-0 ,1 ,-0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.7084s
% % % % Lab 1: 
% % % %   AM:(0.8:([-0 ,1 ,-0])), (1:([0 ,-1 ,0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.6524s
% % % % Lab 1: 
% % % %   AM:(0.8:([0 ,0 ,-1])), (1:([-0 ,-0 ,1]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.1903s
% % % % Lab 1: 
% % % %   AM:(0.8:([-0 ,-0 ,1])), (1:([0 ,0 ,-1]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.2207s
% % % % gmres(20) converged at outer iteration 2 (inner iteration 18) to a solution with relative residual 9.5e-11.
% % % % BUILD_MESH_INFO Begin(1).End. Used time: 0h 0m 0.39363s
% % % % Lab 1: 
% % % %   AM:(0.8:([-1 ,0 ,0])), (1:([1 ,-0 ,-0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.436s
% % % % Lab 1: 
% % % %   AM:(0.8:([1 ,-0 ,-0])), (1:([-1 ,0 ,0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.59s
% % % % Lab 1: 
% % % %   AM:(0.8:([0 ,-1 ,0])), (1:([-0 ,1 ,-0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.237s
% % % % Lab 1: 
% % % %   AM:(0.8:([-0 ,1 ,-0])), (1:([0 ,-1 ,0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.37s
% % % % Lab 1: 
% % % %   AM:(0.8:([0 ,0 ,-1])), (1:([-0 ,-0 ,1]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 17.96s
% % % % Lab 1: 
% % % %   AM:(0.8:([-0 ,-0 ,1])), (1:([0 ,0 ,-1]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.189s
% % % % gmres(20) converged at outer iteration 4 (inner iteration 10) to a solution with relative residual 8.7e-11.
% % % % BUILD_MESH_INFO Begin(1).End. Used time: 0h 0m 3.1366s
% % % % Lab 1: 
% % % %   AM:(0.8:([-1 ,0 ,0])), (1:([1 ,-0 ,-0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 8m 21.451s
% % % % Lab 1: 
% % % %   AM:(0.8:([1 ,-0 ,-0])), (1:([-1 ,0 ,0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 8m 4.0219s
% % % % Lab 1: 
% % % %   AM:(0.8:([0 ,-1 ,0])), (1:([-0 ,1 ,-0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 7m 55.606s
% % % % Lab 1: 
% % % %   AM:(0.8:([-0 ,1 ,-0])), (1:([0 ,-1 ,0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 8m 20.13s
% % % % Lab 1: 
% % % %   AM:(0.8:([0 ,0 ,-1])), (1:([-0 ,-0 ,1]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 8m 2.5469s
% % % % Lab 1: 
% % % %   AM:(0.8:([-0 ,-0 ,1])), (1:([0 ,0 ,-1]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 7m 54.409s
% % % % gmres(20) converged at outer iteration 9 (inner iteration 12) to a solution with relative residual 1e-10.
% % % % \begin{tabular}{ccccccc}
% % % %   \toprule
% % % %   $h$ & $\|u-u_h\|_{L^\infty}$ & order & $\|u-u_h\|_{L^2}$ & order & $|u-u_h|_{\alpha}$ & order \\
% % % %   \midrule
% % % %          0.125 &   6.40e-02 &   0.00 &   1.53e-02 &   0.00 &   1.06e+02 &   0.00 \\
% % % %         0.0625 &   2.90e-02 &   1.14 &   6.46e-03 &   1.24 &   5.74e+01 &   0.89 \\
% % % %        0.03125 &   7.63e-03 &   1.92 &   1.91e-03 &   1.76 &   4.92e+01 &   0.22 \\
% % % %   \bottomrule
% % % % \end{tabular}
% % % % BUILD_MESH_INFO Begin(1).End. Used time: 0h 0m 0.059257s
% % % % Lab 1: 
% % % %   AM:(0.6:([-1 ,0 ,0])), (1:([1 ,-0 ,-0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.2185s
% % % % Lab 1: 
% % % %   AM:(0.6:([1 ,-0 ,-0])), (1:([-1 ,0 ,0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.1823s
% % % % Lab 1: 
% % % %   AM:(0.7:([0 ,-1 ,0])), (1:([-0 ,1 ,-0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.1686s
% % % % Lab 1: 
% % % %   AM:(0.7:([-0 ,1 ,-0])), (1:([0 ,-1 ,0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.1748s
% % % % Lab 1: 
% % % %   AM:(0.8:([0 ,0 ,-1])), (1:([-0 ,-0 ,1]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.152s
% % % % Lab 1: 
% % % %   AM:(0.8:([-0 ,-0 ,1])), (1:([0 ,0 ,-1]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.1825s
% % % % gmres(20) converged at outer iteration 2 (inner iteration 17) to a solution with relative residual 8.9e-11.
% % % % BUILD_MESH_INFO Begin(1).End. Used time: 0h 0m 0.37335s
% % % % Lab 1: 
% % % %   AM:(0.6:([-1 ,0 ,0])), (1:([1 ,-0 ,-0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.261s
% % % % Lab 1: 
% % % %   AM:(0.6:([1 ,-0 ,-0])), (1:([-1 ,0 ,0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.12s
% % % % Lab 1: 
% % % %   AM:(0.7:([0 ,-1 ,0])), (1:([-0 ,1 ,-0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.169s
% % % % Lab 1: 
% % % %   AM:(0.7:([-0 ,1 ,-0])), (1:([0 ,-1 ,0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.32s
% % % % Lab 1: 
% % % %   AM:(0.8:([0 ,0 ,-1])), (1:([-0 ,-0 ,1]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.288s
% % % % Lab 1: 
% % % %   AM:(0.8:([-0 ,-0 ,1])), (1:([0 ,0 ,-1]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.045s
% % % % gmres(20) converged at outer iteration 4 (inner iteration 19) to a solution with relative residual 8e-11.
% % % % BUILD_MESH_INFO Begin(1).End. Used time: 0h 0m 3.0421s
% % % % Lab 1: 
% % % %   AM:(0.6:([-1 ,0 ,0])), (1:([1 ,-0 ,-0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 7m 54.871s
% % % % Lab 1: 
% % % %   AM:(0.6:([1 ,-0 ,-0])), (1:([-1 ,0 ,0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 8m 7.3795s
% % % % Lab 1: 
% % % %   AM:(0.7:([0 ,-1 ,0])), (1:([-0 ,1 ,-0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 8m 42.124s
% % % % Lab 1: 
% % % %   AM:(0.7:([-0 ,1 ,-0])), (1:([0 ,-1 ,0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 9m 22.979s
% % % % Lab 1: 
% % % %   AM:(0.8:([0 ,0 ,-1])), (1:([-0 ,-0 ,1]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 8m 33.965s
% % % % Lab 1: 
% % % %   AM:(0.8:([-0 ,-0 ,1])), (1:([0 ,0 ,-1]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 11m 27.218s
% % % % gmres(20) converged at outer iteration 9 (inner iteration 8) to a solution with relative residual 9e-11.
% % % % \begin{tabular}{ccccccc}
% % % %   \toprule
% % % %   $h$ & $\|u-u_h\|_{L^\infty}$ & order & $\|u-u_h\|_{L^2}$ & order & $|u-u_h|_{\alpha}$ & order \\
% % % %   \midrule
% % % %          0.125 &   6.49e-02 &   0.00 &   1.68e-02 &   0.00 &   9.93e+01 &   0.00 \\
% % % %         0.0625 &   2.92e-02 &   1.15 &   7.26e-03 &   1.21 &   6.04e+01 &   0.72 \\
% % % %        0.03125 &   8.15e-03 &   1.84 &   2.25e-03 &   1.69 &   5.65e+01 &   0.10 \\
% % % %   \bottomrule
% % % % \end{tabular}