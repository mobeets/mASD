%% load
load('data/XY.mat', 'X', 'Y', 'Xxy');
[ny, nt, ns] = size(X);
X_OG = permute(X, [1 3 2]);
Y_OG = Y;
X = reshape(X_OG, ny, nt*ns);
Y = Y_OG(:,10);
D = tools.sqdistSpaceTime(Xxy, ns, nt);

%% cross-validate

% grid hyperparameters
ndeltas = 2;
hypergrid = asd.makeHyperGrid(nan, nan, nan, ndeltas);

% create k-fold cross-validation data
nfolds = 10;
[X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(X, Y, nfolds);

% make objective and score functions
mapFcn = @(X_train, Y_train, hyper, opts) 1; % minimize w.r.t. hyper
scoreFcn = @(X_test, Y_test, w, hyper, opts) asd.logLikelihood(Y_test, X_test, w(1:end-1), hyper(2));
scoreFcn = @(X_test, Y_test, w, hyper, opts) reg.rsq(X_test*w(1:end-1) + w(end), Y_test);

% score all hyperparameters
opts = struct('D', D);
scores = reg.scoreCVGrid(X_train, Y_train, X_test, Y_test, mapFcn, scoreFcn, nfolds, hypergrid, opts);

%%
% function [mu, b] = mapFcn(X_train, Y_train, hyper, opts)
%     fitIntercept = true;    
%     D = opts.D;
%     ssq = hyper(2);
%     [X, Y, X_mean, Y_mean] = reg.centerData(X_train, Y_train, fitIntercept);
%     [XX, XY, YY, p, q, Reg] = asd.init(X, Y, D, hyper);
%     [mu, ~] = tools.meanInvCov(XX, XY, Reg, ssq);
%     b = reg.setIntercept(X_mean, Y_mean, mu, fitIntercept);
% end
