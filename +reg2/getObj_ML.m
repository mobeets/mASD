function obj = getObj_ML(X, Y, obj)
    if nargin < 3
        obj = struct();
    end
    obj = reg2.getObj(X, Y, obj);

    if strcmp(obj.llstr, 'gauss')
        obj.fitFcn = @ml.calcGaussML;
    elseif strcmp(obj.llstr, 'bern')
        obj.fitFcn = @ml.calcBernML;
        opts.fitIntercept = false; % only fitting 0/1
    elseif strcmp(obj.llstr, 'poiss')
        obj.fitFcn = @ml.calcPoissML;
    end
    obj.fitFcnArgs = {};
end
