function obj = getObj_ML_Ridge(X, Y, scoreObj, obj)
    if nargin < 3 || (isa(scoreObj, 'double') && isnan(scoreObj))
        scoreObj = struct();
    end
    if nargin < 4
        obj = struct();
    end
    obj = reg.getObj(X, Y, obj);
    obj.fitType = 'Ridge';
    if ~isfield(obj, 'wML')
        obj.wML = nan;
    end

    if strcmp(obj.llstr, 'gauss')
        obj.fitFcn = @ml.calcGaussML_Ridge;
    end
    obj.fitFcnArgFcn = @(obj) {obj.hyper};
    
    if ~isfield(obj, 'hyperObj')
        if strcmp(obj.llstr, 'gauss')
            obj.hyperObj = reg.getHyperObj_gaussRidge(obj.wML);
        else
            obj.hyperObj = reg.getRidgeHyperObj_grid(X, Y, obj, scoreObj);
        end
    end
end
