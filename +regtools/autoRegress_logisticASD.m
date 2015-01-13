function [wASD, hypers, SDebars, postHess, logevid] = autoRegress_logisticASD(X, Y, D, w0)
% [wRidge,rho,SDebars,postHess,logevid] = autoRegress_logisticASD(xx, yy, iirdge, rhoNull, rhovals, w0)
%
% Computes empirical Bayes logistic ridge regression filter estimate under a
% Bernoulli-GLM with ASD prior
%
% Inputs:
%         X [n x nw]  - stimulus (regressors)
%         Y [n x 1]   - spike counts (response)
%         D [nw x nw] - squared distance matrix
%        w0 [nw x 1]  - initial estimate of regression weights (optional)
%   opts (optional)   = options stucture: fields 'tolX', 'tolFun', 'maxIter','verbose'
%
% Outputs:
%   wRidge [nw x 1]  - empirical bayes estimate of weight vector
%      rho [1 x 1]   - estimate for prior precision (inverse variance)
%  SDebars [nw x 1]  - 1 SD error bars from posterior
% postHess [nw x nw] - Hessian (2nd derivs) of negative log-posterior at
%                    maximum ( inverse of posterior covariance)
%  logevid [1 x 1]   - log-evidence for hyperparameters
%

[ny, nw] = size(X);
ndeltas = size(D, 3);
hypergrid = asd.makeHyperGrid(nan, nan, nan, ndeltas, false);

% initialize filter estimate with MAP regression estimate, if necessary
if nargin < 4
    rho0 = 5;        % initial value of ridge parameter
    Lprior = speye(nw)*rho0;
    w0 = (X'*X)\(X'*Y);
end

% --- set prior and log-likelihood function pointers ---
mstruct.neglogli = @regtools.neglogli_bernoulliGLM;
mstruct.logprior = @regtools.logprior_ASD;
mstruct.liargs = {X, Y};
mstruct.priargs = {D};
mstruct.hprsNoLogit = true;

% --- Do grid search over ASD hyperparameters -----
[hprsMax, wmapMax] = regtools.gridsearch_GLMevidence(w0, mstruct, hypergrid);
fprintf('best grid point: deltas = %.1f\n', hprsMax);

% --- Do gradient ascent on evidence ----
[wASD, hypers, logevid, postHess] = regtools.findEBestimate_GLM(wmapMax, hprsMax, mstruct);

if nargout >2
    SDebars = sqrt(diag(inv(postHess)));
end
