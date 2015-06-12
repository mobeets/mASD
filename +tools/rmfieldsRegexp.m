function obj = rmfieldsRegexp(obj, exprs, recurse)
    if nargin < 3
        recurse = false;
    end
    if isa(exprs, 'char')
        exprs = {exprs};
    end
    
    for ii = 1:numel(exprs)
        obj = fmfieldsRegexp(obj, exprs{ii});
    end
    if recurse
        fs = fieldnames(obj);
        for ii = 1:numel(fs)    
            if isa(obj.(fs{ii}), 'struct')
                obj.(fs{ii}) = tools.rmfieldsRegexp(obj.(fs{ii}), ...
                    exprs, recurse);
            end
        end
    end
end

function obj = fmfieldsRegexp(obj, expr)
    fs = fieldnames(obj);
    rmfs = fs(cellfun(@(x) ~isempty(x), regexp(fs, expr)));
    for jj = 1:numel(rmfs)
        obj = rmfield(obj, rmfs{jj});
    end
end
