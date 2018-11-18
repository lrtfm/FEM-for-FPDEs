function mesh = create_mesh_by_gmsh(dim, geo_file, mesh_file, bgm_file)
    % -clmax float
    space = ' ';
    command = ['gmsh' space geo_file space '-' int2str(dim) ...
                                     space '-o' space mesh_file];
    
    if nargin > 3
        command = [command space '-bgm' space bgm_file ];
    end
    
    [~,~] = system(command);

    suffix = suffix_of_file(mesh_file);

    ele_field_names = {'', 'TRIANGLES', 'TETS'};
    
    if strcmp(suffix, '.m')
        run(mesh_file) % will output struct msh
        mesh.Nodes = msh.POS(:, 1:dim)';
        elements = getfield(msh, ele_field_names{dim});
        mesh.Elements =elements(:, 1:(dim+1))';
    else
        mesh = read_mesh_from_msh(dim, mesh_file);
    end
end

function suffix = suffix_of_file(strname)
    ind = find(strname == '.', 1, 'last');
    if isempty(ind)
        suffix = [];
        return;
    end

    suffix = strname(ind:end);
end
