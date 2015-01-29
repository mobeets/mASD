function [ro, ssq, deltas] = unpackHyper(hyper, isGauss)
% 
% unpacks the hyperparameters (if ~isGauss, there is no ssq)
% 
    if nargin < 2 || isGauss
        ro = hyper(1);
        ssq = hyper(2);
        deltas = hyper(3:end);
    else
        ro = hyper(1);
        ssq = nan;
        deltas = hyper(2:end);
    end
end
