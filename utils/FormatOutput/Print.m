function Print(fid, data, varargin)
    % Print(fid, data, 'Head', HeadCell, 'DataFormat', DFormat, 'OutputFormat', Format);
    % OutputFormat 'Plain' 'TPlain' 'Latex' 'TLatex'
    % DataFormat (cell type: size = 1 row, size(data,2) column) : {'%15.4f', '%15.4g'}
    
    nVargin = length(varargin);
    [n, m] = size(data);
    i = 1;
    headflag = 0;
    outputflag = 0;
    dataflag = 0;
    stringflag = 0;
    while i <= nVargin
        switch lower(varargin{i})
            case 'head'
                Head = varargin{i+1};
                headflag = 1;
            case 'outputformat'
                OutputFormat = varargin{i+1};
                outputflag = 1;
            case 'dataformat'
                DataFormat = varargin{i+1};
                dataflag = 1;
            case 'stringformat'
                stringFormat = varargin{i+1};
                stringflag = 1;
            otherwise
                % error
        end
        i = i + 2;
    end
    if headflag == 0
        Head = cell(1, m);
        for i = 1:m
            Head{i} = ['Column ', int2str(i)];
        end
    end
    if outputflag == 0
        OutputFormat = 'Plain';
    end
    if dataflag == 0
        DataFormat = cell(1, m);
         for i = 1:m
            DataFormat{i} = '%10.3g';
        end
    end
    if stringflag == 0
        for i = 1:m
            stringFormat{i} = '%10s';
        end
    end
    space = ' ';
    tspace = [space space];
    columnsep = ' & ';
    endline = ' \\\\\n';
    toprule = '\\toprule\n';
    midrule = '\\midrule\n';
    bottomrule = '\\bottomrule\n';
    newline = '\n';
    begintableprefix = '\\begin{tabular}{';
    begintablesuffix = '}\n';
    endtable = '\\end{tabular}\n';
    
    switch lower(OutputFormat)
        case 'plain'
            dataFormatStr =  [ConnectStr(DataFormat, space), newline];
            for i = 1:m
                if i == 1
                    fprintf(fid, stringFormat{i}, Head{i});
                else
                    fprintf(fid, [space stringFormat{i}], Head{i});
                end
            end
            fprintf(fid, newline);
            for i = 1:n
                fprintf(fid, dataFormatStr, data(i, :));
            end
        case 'tplain'
            data = data';
            for i = 1:m
                formatStr =  [stringFormat{i}, space, ConnectStr(repmat(DataFormat(i), 1, n), space), newline];
                fprintf(fid, formatStr, Head{i}, data(i, :));
            end
        case 'latex'
            begintable = [begintableprefix, kron(ones(1, m), 'c'), begintablesuffix];
            dataFormatStr = [ConnectStr(DataFormat, columnsep), endline];
            fprintf(fid, begintable);
            fprintf(fid, [tspace toprule]);
            for i = 1:m
                if i ~= 1
                    fprintf(fid, columnsep);
                else
                    fprintf(fid, tspace);
                end
                fprintf(fid, stringFormat{i}, Head{i});
            end
            fprintf(fid, endline);
            fprintf(fid, [tspace midrule]);
            for i = 1:n
                fprintf(fid, [tspace dataFormatStr], data(i, :));
            end
            fprintf(fid, [tspace bottomrule]);
            fprintf(fid, endtable);
        case 'tlatex'
            data = data';
            begintable = [begintableprefix, kron(ones(1, n+1), 'c'), begintablesuffix];
            fprintf(fid, begintable);
            fprintf(fid, [tspace toprule]);
            for i = 1:m
                formatStr =  [stringFormat{i}, columnsep,...
                    ConnectStr(repmat(DataFormat(i), 1, n), columnsep), endline];
                fprintf(fid, [tspace formatStr], Head{i}, data(i, :));
                if i == 1 
                    fprintf(fid, [tspace midrule]);
                end
            end
            fprintf(fid, [tspace bottomrule]);
            fprintf(fid, endtable);
        otherwise
            % error
    end
end

function str = ConnectStr(strCell, sep)
    if nargin < 2
        sep = '';
    end
    n = size(strCell, 2);

    for i = 1:n
        if i == 1
            str = strCell{i};
        else
            str2 = [str, sep, strCell{i}];
            str = str2;
        end
    end
end
