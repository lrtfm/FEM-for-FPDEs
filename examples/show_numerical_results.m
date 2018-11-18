function show_numerical_results(result, isball)
    mesh_info = result.mesh_info;
    dim = size(mesh_info.nodes, 1);
    u = result.u;
    u_exact = result.u_exact;
    u_max = max([u; u_exact]);
    u_min = min([u; u_exact]);
    gap = (u_max-u_min)*0.1;
    z_max = u_max + gap;
    f_max = 10^(-floor(log10(abs(z_max))) + 1);
    z_max = floor(z_max*f_max + 1)/f_max;
    z_min = u_min - gap;
    f_min = 10^(-floor(log10(abs(z_min))) + 1);
    z_min = floor(z_min*f_min - 1)/f_min;
    
    dh = result.dh;
    if dim == 2
        figure('position', [300, 300, 1000, 300])
        subplot(1, 3, 1)
        trisurf(mesh_info.elements', mesh_info.nodes(1, :)', mesh_info.nodes(2, :)', u)
        zlim([z_min, z_max]);
        % trimesh(mesh_info.elements', mesh_info.nodes', u)
        title('Numerical result');xlabel('x_1');ylabel('x_2'); zlabel('u');
        subplot(1, 3, 2)
        trisurf(mesh_info.elements', mesh_info.nodes(1, :)', mesh_info.nodes(2, :)', u_exact)
        zlim([z_min, z_max]);
        title('Exact solution');xlabel('x_1');ylabel('x_2'); zlabel('u\_exact');
        subplot(1, 3, 3)
        trisurf(mesh_info.elements', mesh_info.nodes(1, :)', mesh_info.nodes(2, :)', u_exact - u)
        title('Errors');xlabel('x_1');ylabel('x_2'); zlabel('error');
    elseif dim == 3
        if nargin < 2
            isball = 0;
        end
        args = {'Interpreter', 'latex', 'Fontsize', 14};
        if isball
            [theta, rr] = meshgrid(0:pi*dh/2:2*pi, 0:dh/2:0.5);
            [xx, yy] = pol2cart(theta, rr);
            z = 0;
        else
            xmax = max(mesh_info.nodes(1, :));
            xmin = min(mesh_info.nodes(1, :));
            steps = xmin:dh/2:xmax;
            [xx, yy] = meshgrid(steps, steps);
            z = (xmax+xmin)/2;
            factor = 10^(-log10(abs(z))+1);
            z = floor(z*factor)/factor;
        end
        
        p = [xx(:)'; yy(:)'; z*ones(1, length(xx(:)))];
        v = get_value_on_points(mesh_info, u, p);
        v_exact = get_value_on_points(mesh_info, u_exact, p);
        vv = reshape(v, size(xx));
        vv_exact = reshape(v_exact, size(xx));
        figure('position', [300, 300, 1000, 300])
        subplot(1, 3, 1)
        surf(xx, yy, vv); % title(['z=', num2str(z)]);
        zlim([z_min, z_max]); xlabel('$x_1$',args{:});ylabel('$x_2$', args{:});
        zlabel('$u_h$', args{:});
        title('(a)');
        subplot(1, 3, 2)
        surf(xx, yy, vv_exact); % title(['z=', num2str(z)]);
        zlim([z_min, z_max]); xlabel('$x_1$',args{:});ylabel('$x_2$', args{:}); 
        zlabel('$u$', args{:});
        title('(b)');
        subplot(1, 3, 3)
        surf(xx, yy, vv - vv_exact); % title(['z=', num2str(z)]);
        xlabel('$x_1$',args{:});ylabel('$x_2$', args{:});
        zlabel('$u_h-u$', args{:});
        title('(c)');
    end

end