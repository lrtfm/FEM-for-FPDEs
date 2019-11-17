%%
clc
clear

disp 'Example 4.1 test steady fpde const'
gso = 2;
dh = [1/8, 1/16, 1/32];
alpha = repmat(1.7, 3, 1);
coeff = {1, 0; 1, 0; 1, 0};
p = repmat([2, 1], 3, 1);
vf = 0;

msg = ['tsfsc_left_beta' int2str(vf)];
equ = steady_fpde_const_case(alpha, p, coeff);
equ.msg = msg;
result = arrayfun(@(h)steady_sfpde_solver_const(equ, h, gso, vf), dh ,'UniformOutput',false);
post_steady_result(result, msg)
save(msg);

vf = 1;
msg = ['tsfsc_left_beta' int2str(vf)];
equ = steady_fpde_const_case(alpha, p, coeff);
equ.msg = msg;
result = arrayfun(@(h)steady_sfpde_solver_const(equ, h, gso, vf), dh ,'UniformOutput',false);
post_steady_result(result, msg);
save(msg);
% % % % Result
% % % % Example 4.1 test steady fpde const
% % % % gmres(20) converged at outer iteration 2 (inner iteration 18) to a solution with relative residual 3.4e-11.
% % % % gmres(20) converged at outer iteration 5 (inner iteration 3) to a solution with relative residual 7.6e-11.
% % % % gmres(20) converged at outer iteration 9 (inner iteration 7) to a solution with relative residual 9.1e-11.
% % % % \begin{tabular}{ccccccc}
% % % %   \toprule
% % % %   $h$ & $\|u-u_h\|_{L^\infty}$ & order & $\|u-u_h\|_{L^2}$ & order & $|u-u_h|_{\alpha}$ & order \\
% % % %   \midrule
% % % %          0.125 &   2.58e-01 &   0.00 &   6.88e-02 &   0.00 &   6.32e+01 &   0.00 \\
% % % %         0.0625 &   6.83e-02 &   1.92 &   2.12e-02 &   1.70 &   3.07e+01 &   1.04 \\
% % % %        0.03125 &   1.83e-02 &   1.90 &   6.10e-03 &   1.80 &   1.55e+01 &   0.99 \\
% % % %   \bottomrule
% % % % \end{tabular}
% % % % BUILD_MESH_INFO Begin(1).End. Used time: 0h 0m 0.047676s
% % % % Lab 1: 
% % % %   AM:(0.7:([-1 ,0 ,0])), (1:([1 ,-0 ,-0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.3831s
% % % % Lab 1: 
% % % %   AM:(0.7:([1 ,-0 ,-0])), (1:([-1 ,0 ,0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.1263s
% % % % Lab 1: 
% % % %   AM:(0.7:([0 ,-1 ,0])), (1:([-0 ,1 ,-0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.15s
% % % % Lab 1: 
% % % %   AM:(0.7:([-0 ,1 ,-0])), (1:([0 ,-1 ,0]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.2526s
% % % % Lab 1: 
% % % %   AM:(0.7:([0 ,0 ,-1])), (1:([-0 ,-0 ,1]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.1306s
% % % % Lab 1: 
% % % %   AM:(0.7:([-0 ,-0 ,1])), (1:([0 ,0 ,-1]))(AMF)(NE:4061) Begin(1016).End. Used time: 0h 0m 1.1318s
% % % % gmres(20) converged at outer iteration 2 (inner iteration 17) to a solution with relative residual 7.8e-11.
% % % % BUILD_MESH_INFO Begin(1).End. Used time: 0h 0m 0.35904s
% % % % Lab 1: 
% % % %   AM:(0.7:([-1 ,0 ,0])), (1:([1 ,-0 ,-0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 17.835s
% % % % Lab 1: 
% % % %   AM:(0.7:([1 ,-0 ,-0])), (1:([-1 ,0 ,0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 17.543s
% % % % Lab 1: 
% % % %   AM:(0.7:([0 ,-1 ,0])), (1:([-0 ,1 ,-0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 17.737s
% % % % Lab 1: 
% % % %   AM:(0.7:([-0 ,1 ,-0])), (1:([0 ,-1 ,0]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 17.601s
% % % % Lab 1: 
% % % %   AM:(0.7:([0 ,0 ,-1])), (1:([-0 ,-0 ,1]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 18.002s
% % % % Lab 1: 
% % % %   AM:(0.7:([-0 ,-0 ,1])), (1:([0 ,0 ,-1]))(AMF)(NE:32683) Begin(8171).End. Used time: 0h 0m 17.51s
% % % % gmres(20) converged at outer iteration 5 (inner iteration 2) to a solution with relative residual 8.6e-11.
% % % % BUILD_MESH_INFO Begin(1).End. Used time: 0h 0m 2.9671s
% % % % Lab 1: 
% % % %   AM:(0.7:([-1 ,0 ,0])), (1:([1 ,-0 ,-0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 7m 40.574s
% % % % Lab 1: 
% % % %   AM:(0.7:([1 ,-0 ,-0])), (1:([-1 ,0 ,0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 7m 30.638s
% % % % Lab 1: 
% % % %   AM:(0.7:([0 ,-1 ,0])), (1:([-0 ,1 ,-0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 7m 47.75s
% % % % Lab 1: 
% % % %   AM:(0.7:([-0 ,1 ,-0])), (1:([0 ,-1 ,0]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 7m 35.488s
% % % % Lab 1: 
% % % %   AM:(0.7:([0 ,0 ,-1])), (1:([-0 ,-0 ,1]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 7m 39.093s
% % % % Lab 1: 
% % % %   AM:(0.7:([-0 ,-0 ,1])), (1:([0 ,0 ,-1]))(AMF)(NE:268418) Begin(67105).End. Used time: 0h 8m 1.8894s
% % % % gmres(20) converged at outer iteration 9 (inner iteration 8) to a solution with relative residual 9e-11.
% % % % \begin{tabular}{ccccccc}
% % % %   \toprule
% % % %   $h$ & $\|u-u_h\|_{L^\infty}$ & order & $\|u-u_h\|_{L^2}$ & order & $|u-u_h|_{\alpha}$ & order \\
% % % %   \midrule
% % % %          0.125 &   2.55e-01 &   0.00 &   6.70e-02 &   0.00 &   5.87e+01 &   0.00 \\
% % % %         0.0625 &   6.76e-02 &   1.92 &   2.03e-02 &   1.72 &   3.07e+01 &   0.93 \\
% % % %        0.03125 &   1.79e-02 &   1.91 &   5.67e-03 &   1.84 &   1.55e+01 &   0.99 \\
% % % %   \bottomrule
% % % % \end{tabular}



%%
% clear
% 
% disp 'test steady fpde const left and right'
% gso = 2;
% % dh = 1./2.^(2:1:4);
% dh = [1/8, 1/16, 1/32];
% alpha = repmat(1.8, 3, 1);
% coeff = {0.4, 0.6; 0.5, 0.5; 0.6, 0.4};
% p = repmat([2, 2], 3, 1);
% vf = 0;
% 
% msg = ['tsfsc_lr_beta' int2str(vf)];
% equ = steady_fpde_const_case(alpha, p, coeff);
% equ.msg = msg;
% result = arrayfun(@(h)steady_sfpde_solver_const(equ, h, gso, vf), dh ,'UniformOutput',false);
% post_steady_result(result, msg)
% save(msg);
% 
% vf = 1;
% msg = ['tsfsc_lr_beta' int2str(vf)];
% equ = steady_fpde_const_case(alpha, p, coeff);
% equ.msg = msg;
% result = arrayfun(@(h)steady_sfpde_solver_const(equ, h, gso, vf), dh ,'UniformOutput',false);
% post_steady_result(result, msg);
% save(msg);

%%
% clear
% 
% disp 'test steady fpde const left and right'
% gso = 2;
% % dh = 1./2.^(2:1:4);
% dh = [1/8, 1/16, 1/32];
% alpha = repmat(1.8, 3, 1);
% coeff = {0.5, 0.5; 0.5, 0.5; 0.5, 0.5};
% p = repmat([2, 2], 3, 1);
% vf = 0;
% 
% msg = ['tsfsc_lr_s_beta' int2str(vf)];
% equ = steady_fpde_const_case(alpha, p, coeff);
% equ.msg = msg;
% result = arrayfun(@(h)steady_sfpde_solver_const(equ, h, gso, vf), dh ,'UniformOutput',false);
% post_steady_result(result, msg)
% save(msg);
% 
% vf = 1;
% msg = ['tsfsc_lr_s_beta' int2str(vf)];
% equ = steady_fpde_const_case(alpha, p, coeff);
% equ.msg = msg;
% result = arrayfun(@(h)steady_sfpde_solver_const(equ, h, gso, vf), dh ,'UniformOutput',false);
% post_steady_result(result, msg);
% save(msg);
%%
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

