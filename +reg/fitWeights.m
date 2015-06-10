function [mu, b] = fitWeights(X, Y, obj)
% function [mu, b] = fitWeights(X, Y, obj)
% 
% X, Y - return best mu,b s.t. Y ~ X*mu + b
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
    mu = obj.fitFcn(X, Y, obj.fitFcnArgs{:});
    predictionFcn = reg.getPredictionFcn(obj.isLinReg);
	b = tools.setIntercept(X_mean, Y_mean, mu, obj.fitIntercept, ...
        predictionFcn);
end
