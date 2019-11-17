function [mesh_info, domain] = get_mesh_info(domain, dh)
    if isfield(domain, 'model_flag') && domain.model_flag == 1
    	mesh_st = generateMesh(domain.model, 'GeometricOrder', 'linear', 'Hmax', dh);
    else 
        mesh_st = create_mesh(domain.x_range, 1/dh);
    end
    mesh_info = build_mesh_info(mesh_st);
end