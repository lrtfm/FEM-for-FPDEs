function mesh_info = pre_comput_gp_and_index(mesh_info, gso)
    [gps, ws] = get_all_gauss_points(mesh_info, gso);
    [index_col, index_row] = get_index_col_row(mesh_info);
    mesh_info.gp = gps;
    mesh_info.w = ws;
    mesh_info.index_col = index_col;
    mesh_info.index_row = index_row;
end