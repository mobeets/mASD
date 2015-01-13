load('data/XY.mat', 'X', 'Y', 'Xxy');
[ny, nt, ns] = size(X);
X_OG = permute(X, [1 3 2]);
Y_OG = Y;

Xf = reshape(X_OG, ny, nt*ns);
Y10 = Y_OG(:,10);

%% rand

wf = 1 - 2*rand(nt, ns);
plot.plotKernel(Xxy, wf);

%% regression init

trainPct = 0.8;
fitIntercept = true;
X = Xf; Y = Y10;
if false
    [X0, Y0, X1, Y1] = reg.trainAndTest(X, Y, trainPct);
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
% disp(['OLS rsq = ', num2str(reg.rsq(X1*mu + b, Y1))])
wf = reshape(mu, ns, nt);
plot.plotKernel(Xxy, wf, nan, nan, nan, 'OLS');

%% ASD

D = tools.sqdistSpaceTime(xy, ns, nt);

[mu, Reg, hyper] = asd.gaussASD(X, Y, D, nan, true);
b = reg.setIntercept(X_mean, Y_mean, mu, fitIntercept);
disp(['ASD rsq = ', num2str(reg.rsq(X1*mu + b, Y1))])
wf = reshape(mu, ns, nt);
plot.plotKernel(Xxy, wf, nan, nan, nan, 'ASD');
[evi, nll] = asd.gaussScores(X, Y, X1, Y1, D, hyper);

%%

hyper0 = [0.80489924 11.25667696 16.75620794 0.13739696];
asd.calcGaussLogLikelihood(X1, Y1, D, hyper0)
