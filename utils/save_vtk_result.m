function save_vtk_result(vtkpath, vtkbasename, n, i, mesh_info, varargin)
    if nargin < 7 || mod(nargin - 1, 2) 
        error('Argument number is wrong!');
    end

    if mkdir(vtkpath)
        format = sprintf('%%s%%0%gg.vtk', ceil(log10(n) + 1));
        vtkname = sprintf(format, vtkbasename, i);
        vtkfullname = fullfile(vtkpath, vtkname);
        out2vtk(vtkfullname, mesh_info, varargin{:});
    else
        warning('Creat Config:SaveVtkPath %s failed!!!\n', vtkpath)
    end
end