function [p, dp, negCinv, logdetrm] = logprior_ASD(prvec, hypers, D)
% [p, dp, negCinv, logdetrm] = logprior_ASD(prvec, hypers, D)
%
% Evaluate a Gaussian log-prior at parameter vector prvec.
%
% Inputs:
%   prvec [n x 1]        - parameter vector (last element can be DC)
%  hypers [nr x 1]       - ASD hyperparameters
%       D [n x n x nr-2] - squared distance matrix
%
% Outputs:
%       p [1 x 1] - log-prior
%      dp [n x 1] - grad
% negCinv [n x n] - inverse covariance matrix (Hessian)
%  logdet [1 x 1] - log-determinant of -negCinv (optional)
%

% check for included DC term
if numel(prvec) == size(D,1) + 1
    prvec = prvec(1:end-1);
end

[ro, ~, deltas] = asd.unpackHyper(hypers);
C = asd.prior(ro, D, deltas);

p = prvec'*(C\prvec);
dp = [];

if nargout > 2
    negCinv = -C\eye(size(C,1));
    logdetrm = sum(log(Cinvdiag));
end
