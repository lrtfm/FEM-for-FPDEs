function mesh = read_mesh_from_msh(dim, filename)
    fid = fopen(filename);
    count = 2;
    while count
        section = get_section_name(fid);
        if strcmp(section, 'Nodes')
            nodes = read_nodes(fid);
            count = count - 1;
        elseif strcmp(section, 'Elements')
            elements = read_elements(dim, fid);
            count = count - 1;
        else
            skip_section(fid, section);
        end
    end
    fclose(fid);
    mesh.Nodes = nodes(1:dim, :);
    mesh.Elements = elements;
end

function elements = read_elements(dim, fid)
    line = fgetl(fid);
    A = sscanf(line,'%d');
    ns = A(1);
    ele_type = [0, 2, 4];
    for i = 1:ns
        line = fgetl(fid);
        B = sscanf(line, '%d');
        if B(2) == dim && B(3) == ele_type(dim)
            elements = zeros(dim+1, B(4));
            for j = 1:B(4)
                line = fgetl(fid);
                C = sscanf(line,'%d');
                elements(:, j) = C(2:dim+2);
            end
            break
        else
            for j = 1:B(4)
                skip_line = fgetl(fid);
            end
        end
    end
end

function nodes = read_nodes(fid)
    line = fgetl(fid);
    A = sscanf(line,'%d');
    ns = A(1);
    nn = A(2);
    nodes = zeros(3, nn);
    k = 0;
    for i = 1:ns
        line = fgetl(fid);
        B = sscanf(line,'%d');
        % assert(B(3) == 0 && B(2) == 0)
        np = B(4);
        for j = 1:np
            line = fgetl(fid);
            C = sscanf(line, '%f');
            k = k + 1;
            nodes(:, k) = C(2:4);
        end
    end
    line = fgetl(fid);
    assert(strcmp(line, '$EndNodes')==1);
end

function skip_section(fid, section)
    endstr = ['$End' section];
    line = '';
    while strcmp(endstr, line) == 0
        line = fgetl(fid);
    end
end

function section = get_section_name(fid)
    line = fgetl(fid);
    if strcmp(line(1), '$')
        section = line(2:end);
    else
        error('Format error of msh file');
    end
    
end