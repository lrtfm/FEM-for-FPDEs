function show_numerical_results_ball(result)
    mesh_info = result.mesh_info;
    % dim = size(mesh_info.nodes, 1);
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
    args = {'Interpreter', 'latex', 'Fontsize', 14};
    dh = result.dh;
    % trimesh(tri, x, y, z);
    [tri, xx, yy] = get_mesh2d(0.5, dh);
    z = 0;
    p = [xx(:)'; yy(:)'; z*ones(1, length(xx(:)))];
    v = get_value_on_points(mesh_info, u, p);
    v_exact = get_value_on_points(mesh_info, u_exact, p);
    vv = reshape(v, size(xx));
    vv_exact = reshape(v_exact, size(xx));
    figure('position', [300, 300, 1000, 300])
    subplot(1, 3, 1)
    trisurf(tri, xx, yy, vv); % title(['z=', num2str(z)]);
    zlim([z_min, z_max]); xlabel('$x_1$',args{:});ylabel('$x_2$', args{:});
    zlabel('$u_h$', 'Interpreter', 'latex', 'Fontsize', 14);
    title('(a)');
    subplot(1, 3, 2)
    trisurf(tri, xx, yy, vv_exact); title(['z=', num2str(z)]);
    zlim([z_min, z_max]); xlabel('$x_1$',args{:});ylabel('$x_2$', args{:}); 
    zlabel('$u$', 'Interpreter', 'latex', 'Fontsize', 14);
    title('(b)');
    subplot(1, 3, 3)
    trisurf(tri, xx, yy, vv - vv_exact); % title(['z=', num2str(z)]);
    xlabel('$x_1$',args{:});ylabel('$x_2$', args{:});
    zlabel('$u_h-u$', 'Interpreter', 'latex', 'Fontsize', 14);
    title('(c)');

end


function [tri, x, y] = get_mesh2d(r, h)
    Area.gd = [ 4; 0; 0; r; r; 0];
    Area.ns = char('C1')';
    Area.sf = 'C1';
    [dl,~]=decsg(Area.gd, Area.sf, Area.ns);
    [points,~,triangle]=initmesh(dl, 'Hmax', h);
    x = points(1, :);
    y = points(2, :);
    tri = triangle(1:3, :)';
end
