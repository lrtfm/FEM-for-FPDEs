function fprint_vtk(filename, nodes, elements, varargin)
    if nargin < 5 || mod(nargin-1, 2) 
        error('Argument number is wrong!');
    end
	fid = fopen(filename, 'w');
	fprintf(fid, '# vtk DataFile Version 3.0\n');
	fprintf(fid, 'Export 3D data from Matlab\n');
	fprintf(fid, 'ASCII\n');

	fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');
	n = size(nodes, 2);
	fprintf(fid, 'POINTS %d float\n', n);
	for i = 1:n
		fprintf(fid, '%g %g %g\n', nodes(:, i));
	end
	elements = elements - 1;
	m = size(elements, 2);
	fprintf(fid, 'CELLS %d %d\n', m, 5*m);
	for i = 1:m
		fprintf(fid, '4 %d %d %d %d\n', elements(:, i));
	end
	fprintf(fid, 'CELL_TYPES %d\n', m);
    for i = 1:m
        fprintf(fid, '10\n');
    end

    fprintf(fid, 'POINT_DATA %d\n', n);
    for k = 1:2:length(varargin)
        u = varargin{k};
        name = varargin{k+1};
        fprintf(fid, 'SCALARS %s float\n', name);
        fprintf(fid, 'LOOKUP_TABLE default\n');
        for i = 1:n
            fprintf(fid, '%g\n', u(i));
        end
    end

    fclose(fid);
end
