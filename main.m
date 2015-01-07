load('data/XY.mat', 'X', 'Y', 'Xxy');
[ny, nt, ns] = size(X);
X_OG = permute(X, [1 3 2]);
Y_OG = Y;

Xf = reshape(X_OG, ny, nt*ns);
Y10 = Y_OG(:,10);

%% rand

wf = 1 - 2*rand(nt, ns);
plotKernel(Xxy, wf);

%% regression init

trainPct = 0.8;
fitIntercept = true;
X = Xf; Y = Y10;
if false
    [X0, X1, Y0, Y1] = reg.trainAndTest(X, Y, trainPct);
else
    ind = 800;
    X0 = Xf(1:ind, :);
    X1 = Xf(ind+1:end, :);
    Y0 = Y10(1:ind);
    Y1 = Y10(ind+1:end);
end
X = X0; Y = Y0;
[X, Y, X_mean, Y_mean] = reg.centerData(X, Y, fitIntercept);

%% OLS

XX = X'*X;
XY = X'*Y;
mu = XX\XY;
b = reg.setIntercept(X_mean, Y_mean, mu, fitIntercept);
disp(['OLS rsq = ', num2str(reg.rsq(X1*mu + b, Y1))])
wf = reshape(mu, nt, ns);
plotKernel(Xxy, wf, nan, nan, nan, 'OLS');

%% ASD

% make combined spatial/temporal squared distance matrix, D
Ds = repmat(sqdist(Xxy), nt, nt);
Dt = sqdistTime(nt, ns);
D = nan(ns*nt, ns*nt, 2);
D(:,:,1) = Ds;
D(:,:,2) = Dt;

[mu, Reg, hyper] = asd.asd(X, Y, D, nan, true);
b = reg.setIntercept(X_mean, Y_mean, mu, fitIntercept);
disp(['ASD rsq = ', num2str(reg.rsq(X1*mu + b, Y1))])
wf = reshape(mu, nt, ns);
plotKernel(Xxy, wf, nan, nan, nan, 'ASD');
[evi, nll] = asd.scores(X, Y, X1, Y1, D, hyper)
%%

% problem: inv(Reg) is incredibly inaccurate
% inv(Reg)*Reg should have total sum close to nt*ns, but it's way off...
hyper0 = [0.80489924 11.25667696 16.75620794 0.13739696];
asd.calcLogLikelihood(X1, Y1, D, hyper0)
