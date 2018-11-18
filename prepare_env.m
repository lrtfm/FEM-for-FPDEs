function prepare_env()
    filefullname = mfilename('fullpath');
    cpath = fileparts(filefullname);

    subdir = {'core', 'utils', 'examples', 'gmsh_utils'};
    fullsubdir = cellfun(@(x)fullfile(cpath, x), subdir, 'UniformOutput', false);
    addpath(fullsubdir{:});
    
    core_path = fullsubdir{1};
    utils_path = fullsubdir{2};
    addpath(genpath(utils_path));
    oldpwd = cd(core_path);
    mex -largeArrayDims add_sparse.c
    % mex -output get_intersect_point_mex gip.c
    cd(oldpwd);
end