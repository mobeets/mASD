function obj = getObj(X, Y, obj)
    if nargin < 3
        obj = struct();
    end
    obj = tools.structDefaults(obj, ...
        {'fitIntercept', 'centerX'}, {true, false});
    if ~isfield(obj, 'llstr')
        if numel(unique(Y)) == 2
            obj.llstr = 'bern';
        else
            obj.llstr = 'gauss';
        end
    end
    if strcmp(obj.llstr, 'bern')
        obj = tools.structDefaults(obj, ...
            {'isLinReg', 'fitIntercept'}, {false, false});
    else
        obj = tools.structDefaults(obj, ...
            {'isLinReg'}, {true});
    end
    if ~isfield(obj, 'foldinds')
        obj = tools.structDefaults(obj, ...
            {'nfolds'}, {5});
        [~, foldinds] = tools.trainAndTestKFolds(X, Y, obj.nfolds);
        obj.foldinds = foldinds;
    end
end
