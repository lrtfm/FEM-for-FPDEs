function print2latex(p, fun, start_line, end_line, indent)
    if nargin < 5
        indent = 0;
    end
    index  = 0;
    for i = 1:length(p.FunctionTable)
        if strcmp(p.FunctionTable(i).FunctionName, fun)
            index = i;
            break
        end
    end
    
    if index == 0
        error('print2latex: function:%s not found!', fun)
    end

    pf = p.FunctionTable(index);

    fid = fopen(pf.FileName);
    tline = fgetl(fid);
    i = 0;
    seps = '!#@*';
    fixed = ''; % fixed = '[columns=fixed]';
    fprintf(1, '\\begin{table}\\ttfamily\\tiny\n');
    fprintf(1, '  \\caption{Profile info of function \\lstinline[basicstyle=\\scriptsize]!%s!}\n', fun);
    fprintf(1, '  \\begin{tabular}{*{3}{r}l}\\hline\n');
    fprintf(1, '  time & calls & line & code \\\\\\hline\n');
    n = ceil(log10(max(pf.ExecutedLines)))+1;
    n(3) = n(3) + 2;
    while ischar(tline)
        i = i + 1;
        if i < start_line || i > end_line
            tline = fgetl(fid);
            continue
        end
        index = find(pf.ExecutedLines(:, 1) == i, 1);
        if isempty(index)
            fprintf(1, '  %*s& %*s & %*g&', n(3)+1, '', n(2), '', n(1), i);
        else
            t = pf.ExecutedLines(index, :);
            % s(3) = s(3) * (s(3) > 0.1);

            fprintf(1, '  %*.2f & %*d & %*g&', n(3), t(3), n(2), t(2), n(1), t(1));
        end
        if length(tline) > indent*4
            tline = tline(indent*4+1:end);
        end
        j = 1;
        while j <= length(seps)
            sep = seps(j);
            if find(tline == sep, 1)
                j = j + 1;
                continue
            else
                break
            end
        end
        if j > length(seps)
            error('print2latex: latex code same!')
        end
            
        fprintf(1, '\\lstinline%s%s%s%s \\\\\n', fixed, sep, tline, sep);
        tline = fgetl(fid);
    end
    fclose(fid);
    fprintf(1, '  \\hline\n');
    fprintf(1, '  \\end{tabular}\n');
    fprintf(1, '\\end{table}\n');
end