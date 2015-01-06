load('XY.mat', 'X', 'Y', 'Xxy');
[ny, nt, ns] = size(X);
X0 = X;
Y0 = Y;

Xf = reshape(X0, ny, nt*ns);
Y10 = Y(:,10);

%% rand

wf = 1 - 2*rand(nt, ns);
plotKernel(Xxy, wf);

%% regression init

X = Xf;
Y = Y10;
trainPct = 0.8;
[X0, X1, Y0, Y1] = trainAndTest(X, Y, trainPct);

%% OLS

XX = X'*X;
XY = X'*Y;
mu = XX\XY;
wf = reshape(mu, nt, ns);
plotKernel(Xxy, wf);

%% ASD

% make combined spatial/temporal squared distance matrix, D
Ds = repmat(sqdist(Xxy), nt, nt);
Dt = sqdistTime(nt, ns);
D = nan(ns*nt, ns*nt, 2);
D(:,:,1) = Ds;
D(:,:,2) = Dt;

[mu, Reg, hyper] = asd(X0, Y0, D, nan, true);
wf = reshape(mu, nt, ns);
plotKernel(Xxy, wf);

%% TO DO

% 1. fit_intercept
% 2. scores (rsq, nll)
