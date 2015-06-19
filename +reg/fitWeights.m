function [w, b] = fitWeights(X, Y, obj)
% function [w, b] = fitWeights(X, Y, obj)
% 
% X, Y - return best w,b s.t. Y ~ X*w + b
% obj is struct
%   - obj.isLinReg [bool]
%   - obj.fitIntercept [bool]
%   - obj.centerX [bool]
%   - obj.fitFcn = @(X, Y, obj.fitFcnArgs{:}) ...;
%   - obj.fitFcnArgs = {...};
% 
% Example (OLS):
%     isLinReg = true;
%     fitFcn = @(X, Y) (X'*X)\(X'*Y);
%     obj = struct('centerX', false, 'fitIntercept', isLinReg, ...
%         'isLinReg', isLinReg, 'fitFcn', fitFcn, 'fitFcnArgs', {});
%     [w, b] = fitWeights(X, Y, obj);
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
