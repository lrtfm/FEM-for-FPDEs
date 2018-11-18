function ret = get_path_config(name)
    cpath = mfilename('fullpath');
    filepath = fileparts(cpath);
    configu = 'path_config_user.m';
    configd = 'path_config_default.m';
    fcd = [filepath filesep configd];
    run(fcd);
    fcu = [filepath filesep configu];
    if exist(fcu, 'file')
        run(fcu)

    end
    if exist(name, 'var')
        ret = eval(name);
    else
        error('Config %s Not Found', name);
    end
    n = length(name);
    if n > 3 && strcmp('Path', name(n - 3: n)) && ~isempty(ret)
        ret = fullfile(filepath, ret);
    end
end