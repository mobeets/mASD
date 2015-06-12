function [w, b] = fitWeights(X, Y, obj)
% function [w, b] = fitWeights(X, Y, obj)
% 
% X, Y - return best w,b s.t. Y ~ X*w + b
% obj is struct
%   - obj.isLinReg
%   - obj.fitIntercept
%   - obj.centerX
%   - obj.fitFcn
%   - obj.fitFcnArgs
%     
    [X, Y, X_mean, Y_mean] = tools.centerData(X, Y, ...
        obj.fitIntercept, obj.centerX);
    if isfield(obj, 'fitFcnArgFcn')
        obj.fitFcnArgs = obj.fitFcnArgFcn(obj);
    end
    w = obj.fitFcn(X, Y, obj.fitFcnArgs{:});
    predictionFcn = reg.getPredictionFcn(obj.isLinReg);
	b = tools.setIntercept(X_mean, Y_mean, w, obj.fitIntercept, ...
        predictionFcn);
end
