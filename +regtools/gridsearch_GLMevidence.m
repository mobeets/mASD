function [hprsmax, wmap, maxlogev, logevids] = gridsearch_GLMevidence(w0, mstruct, hh)
% [hprsmax,wmap,maxlogev,logevids] = gridsearch_GLMevidence(w0, mstruct, varargin)
%
% Search 1d, 2d or 3D grid of hyperparameters for maximum evidence (i.e.,
% for initializing gradient ascent of evidence) 
% 
% Maximizes posterior and uses Laplace approximation to evaluate evidence (marginal likelihood) at each grid point  for
%
% INPUTS:
%  wts [m x 1] - regression weights
%  mstruct - model structure with fields
%        .neglogli - func handle for negative log-likelihood
%        .logprior - func handle for log-prior 
%        .liargs - cell array with args to neg log-likelihood
%        .priargs - cell array with args to log-prior function
%   hh [ngrid x 4] - hyperparameter grid
%
% OUTPUTS:
%  hprsmax - hyperparameters maximizing marginal likelihood on grid
%     wmap - MAP estimate at evidence maximum
% maxlogev - value of log-evidence at maximum
% logevids - log-evidence across entire grid 
%

% Optimization parameters (for finding MAP estimate)
opts = struct('tolX',1e-8,'tolFun',1e-8,'maxIter',1e4,'verbose',0);

% Allocate space for output variables
ngrid = size(hh,1);
wmaps = zeros(length(w0),ngrid);
logevids = zeros(ngrid,1);

% Search grid
fprintf('\n%d gridpts:',ngrid);
for jj = 1:ngrid
    hh_itr = hh(jj,:)';  % hyperparameters for this iteration
    lfpost = @(w)(neglogpost_GLM(w,hh_itr,mstruct));
    wmap_itr = fminNewton(lfpost,w0,opts);
    logevids(jj) = logevid_GLM(wmap_itr,hh_itr,mstruct);
    wmaps(:,jj) = wmap_itr;

    if mod(jj,5)==0
	fprintf(' %d', jj);
    end
end
fprintf('\n');

% Extract outputs
[maxlogev,jjmax] = max(logevids);
wmap = wmaps(:,jjmax);
hprsmax = hh(jjmax,:)';
if nargout >= 4
   logevids = reshape(logevids,size(h1));
end
