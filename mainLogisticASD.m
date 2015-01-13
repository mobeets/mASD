%%
% addpath('zaso'); % needed for poisson regression
load('data/XY.mat', 'X', 'Y', 'Xxy', 'R');
[ny, nt, ns] = size(X);
X_OG = permute(X, [1 3 2]);
Y_OG = Y;
X = reshape(X_OG, ny, nt*ns);
Y = Y_OG(:,10);
D = tools.sqdistSpaceTime(Xxy, ns, nt);

%%

[ny, nw] = size(X);
ndeltas = size(D, 3);
hypergrid = asd.makeHyperGrid(nan, nan, nan, ndeltas, false);

mstruct.neglogli = @regtools.neglogli_bernoulliGLM;
mstruct.logprior = @regtools.logprior_ASD;
mstruct.liargs = {X, Y};
mstruct.priargs = {D};
mstruct.hprsNoLogit = true;

w0 = (X'*X)\(X'*Y);

hh_itr = hypergrid(1,:)'  % hyperparameters for this iteration
lfpost = @(w) regtools.neglogpost_GLM(w, hh_itr, mstruct);
opts = struct('tolX', 1e-8, 'tolFun', 1e-8, 'maxIter', 1e4, 'verbose', 0);
wmap_itr = tools.fminNewton(lfpost, w0, opts);

%%
[wASD, hypers, SDebars, postHess, logevid] = autoRegress_logisticASD(X, Y, D);
