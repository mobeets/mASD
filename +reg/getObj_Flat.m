function obj = getObj_Flat(X, Y, obj)
    if nargin < 3
        obj = struct();
    end
    obj = reg.getObj(X, Y, obj);
    obj.fitType = 'null';

    if strcmp(obj.llstr, 'gauss')
        obj.fitFcn = @(X, Y) ml.calcGaussML(sum(X,2), Y)*ones(size(X,2),1);
    elseif strcmp(obj.llstr, 'bern')
        obj.fitFcn = @(X, R) 1*ones(size(X,2),1);
    end
    obj.fitFcnArgs = {};
end
