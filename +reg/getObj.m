function obj = getObj(X, Y, obj)
    if nargin < 3
        obj = struct();
    end
    obj = tools.updateOptsWithDefaults(obj, ...
        {'fitIntercept', 'centerX'}, {true, false});
    if ~isfield(obj, 'llstr')
        if numel(unique(Y)) == 2
            obj.llstr = 'bern';
            obj.isLinReg = false;
            obj.fitIntercept = false;
        else
            obj.llstr = 'gauss';
            obj.isLinReg = true;
        end
    end
    if ~isfield(obj, 'foldinds')
        obj.nfolds = 5;
        [~, foldinds] = tools.trainAndTestKFolds(X, Y, obj.nfolds);
        obj.foldinds = foldinds;
    end
end
