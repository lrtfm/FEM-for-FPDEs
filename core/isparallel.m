function b = isparallel()
    b = (exist('__auto__','file') && ~isempty(gcp())) || ~isempty(gcp('nocreate'));
end