function obj = getObj_ML(X, Y, obj)
    if nargin < 3
        obj = struct();
    end
    obj = reg.getObj(X, Y, obj);
    obj.fitType = 'ML';

    if strcmp(obj.llstr, 'gauss')
        obj.fitFcn = @ml.calcGaussML;
    elseif strcmp(obj.llstr, 'bern')
        obj.fitFcn = @ml.calcBernML;
    elseif strcmp(obj.llstr, 'poiss')
        obj.fitFcn = @ml.calcPoissML;
    end
    obj.fitFcnArgs = {};
end
