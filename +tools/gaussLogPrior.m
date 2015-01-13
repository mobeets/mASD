function [p, dp, negCinv] = gaussLogPrior(w, mu, C, isInv)
% [p, dp, negCinv] = gaussPrior(w, mu, C, isInv)
%
% Evaluate a Gaussian log-prior at parameter vector w.
%
% Inputs:
%   prvec [n x 1] - parameter vector (last element can be DC)
%      mu [m x 1] - gaussian mean
%       C [m x m] - gaussian covariance or inverse covariance
%   isInv [logical] - if true, C is inverse covariance; else, covariance
%
% Outputs:
%       p [1 x 1] - log-prior
%      dp [n x 1] - grad
% negCinv [n x n] - inverse covariance matrix (Hessian)
%

% check for included DC term
if numel(w) == size(C,1) + 1
    w = w(1:end-1);
end
if isInv
    Cinv = C;
else
    Cinv = C \ eye(size(C,1));
end

p = -0.5*(w-mu)'*Cinv*(w-mu);
dp = -Cinv*(w-mu);
% if w is [n x v], diag(p) is [1 x v]
p = diag(p)';

if nargout > 2
    negCinv = -Cinv;
end
