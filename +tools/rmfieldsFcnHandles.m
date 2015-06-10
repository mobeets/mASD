function obj = rmfieldsFcnHandles(obj)
    fs = fieldnames(obj);
    for ii = 1:numel(fs)
        if isa(obj.(fs{ii}), 'function_handle')
            obj = rmfield(obj, fs{ii});
        elseif isa(obj.(fs{ii}), 'struct')
            obj.(fs{ii}) = tools.rmFcnHandles(obj.(fs{ii}));
        end
    end
end
