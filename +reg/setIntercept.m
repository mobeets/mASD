function v = setIntercept(X_mean, Y_mean, w, fitIntercept)
% function v = setIntercept(X_mean, Y_mean, w, fitIntercept)
% 
% if fitIntercept, returns the residual of the prediction:
%   Y_mean - X_mean*w
% 
    if fitIntercept
        v = Y_mean - X_mean*w;
    else
        v = 0.0;
    end
end
