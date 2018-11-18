dim = 3;
h = 0.2;
geo_file_name = 'mygeo.geo';

create_geo_file(dim, geo_file_name, h);

m_script_name = 'mygenerate_code.m';
mesh = create_mesh_by_gmsh(dim, geo_file_name, m_script_name);
msh_file_name = 'mygenerate.msh';
create_mesh_by_gmsh(dim, geo_file_name, msh_file_name);

mesh2 = read_mesh_from_msh(dim, msh_file_name);

bgm_file_name = 'mybgmm.pos';
bgm_field.mesh = mesh2;
bgm_field.h = h*ones(size(mesh2.Nodes, 2), 1);
output_bgm_file(dim, bgm_file_name, bgm_field)

mesh_st = create_mesh_by_gmsh(dim, geo_file_name, m_script_name, bgm_file_name);

h_new = get_value_on_points(bgm_field.mesh, bgm_field.h, mesh_st.Nodes);

bgm_field.mesh = mesh_st;
bgm_field.h = h_new;
