function mu = calcBilinear(X, Y, sFcn, sFcnOpts, tFcn, tFcnOpts, opts)
% function mu = calcBilinear(X, Y, sFcn, sFcnOpts, tFcn, tFcnOpts, opts)
% 
% solves for space and time weights using alternating least squares
%   where time weights are fit with tFcn, and space weights with sFcn
% 
% X [ny x ns x nt]
% Y [ny x 1]
% sFcn - space marginal fitting function
% sFcnOpts [cell] - optional arguments passed to sFcn
% tFcn - time marginal fitting function
% tFcnOpts [cell] - optional arguments passed to tFcn
% opts [struct] (optional)
%   .maxiters - max number of iterations of ALS
%   .tol - if the marginal sum change of mu is less than this, stop
%   .wt0 - initial time weights
% 
% example:
%   sFcn = @asd.gauss.calcMAP;
%   sFcnOpts = {hyper, Ds};
%   tFcn = @ml.calcGaussML;
%   tFcnOpts = {};
%
    if nargin < 7
        opts = struct();
    end
    if ~isfield(opts, 'maxiters')
        opts.maxiters = 100;
    end
    if ~isfield(opts, 'tol')
        opts.tol = 1e-6;
    end
    if ~isfield(opts, 'wt0')        
        wt = ones(size(X,3),1);
    else
        wt = opts.wt0;
    end
    
    muPrev = nan(size(X,2),size(X,3));
    for ii = 1:opts.maxiters
        Xt = Xwt(X, wt);
        ws = sFcn(Xt, Y, sFcnOpts{:});
        Xs = Xws(X, ws);
        wt = tFcn(Xs, Y, tFcnOpts{:});
        mu = ws*wt';
        if abs(sum(sum(mu - muPrev))) < opts.tol
            break;
        end
        muPrev = mu;
    end
end

function Xt = Xwt(X, wt)
    [ny, ns, ~] = size(X);
    Xt = nan(ny, ns);
    for ii = 1:ny
        Xt(ii,:) = squeeze(X(ii,:,:))*wt;
    end
end

function Xs = Xws(X, ws)
    [ny, ~, nt] = size(X);
    Xs = nan(ny, nt);
    for ii = 1:ny
        Xs(ii,:) = squeeze(X(ii,:,:))'*ws;
    end
end
