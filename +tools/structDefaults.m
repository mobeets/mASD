function opts = structDefaults(opts, names, vals)
    for ii = 1:numel(names)
        if ~isfield(opts, names{ii})
            opts.(names{ii}) = vals{ii};
        end
    end
end
