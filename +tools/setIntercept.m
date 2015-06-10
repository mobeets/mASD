function v = setIntercept(X_mean, Y_mean, w, fitIntercept, predictionFcn)
% function v = setIntercept(X_mean, Y_mean, w, fitIntercept)
% 
% if fitIntercept, returns the residual of the prediction:
%   Y_mean - X_mean*w
% 
    if nargin < 5
        predictionFcn = @(X, w) X*w;
    end
    if fitIntercept
        v = Y_mean - predictionFcn(X_mean, w);
    else
        v = 0.0;
    end
end
