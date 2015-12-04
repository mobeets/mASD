function obj = getObj_ML_ARD(X, Y, scoreObj, obj)
    if nargin < 3 || (isa(scoreObj, 'double') && isnan(scoreObj))
        scoreObj = struct();
    end
    if nargin < 4
        obj = struct();
    end
    obj = reg.getObj(X, Y, obj);
    obj.fitType = 'ML';

    if strcmp(obj.llstr, 'gauss')
        obj.fitFcn = @ml.calcGaussML_ARD;
    end
    obj.fitFcnArgFcn = @(obj) {obj.hyper};
    
    if ~isfield(obj, 'hyperObj')
        obj.hyperObj = reg.getHyperObj_gaussARD(obj.wML, obj.pRdg);
    end
end
