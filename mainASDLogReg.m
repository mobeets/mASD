%% load

load('data/XY.mat', 'X', 'Y', 'Xxy');
[ny, nt, ns] = size(X);
X_OG = permute(X, [1 3 2]);
Y_OG = Y;
X = reshape(X_OG, ny, nt*ns);
Y = Y_OG(:,10);
D = tools.sqdistSpaceTime(Xxy, ns, nt);

%% init

% grid hyperparameters
ndeltas = 2;
hypergrid = asd.makeHyperGrid(nan, nan, nan, ndeltas, false);

% create k-fold cross-validation data
nfolds = 10;
[X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(X, Y, nfolds);

% make objective and score functions
% mapFcn = @(X_train, Y_train, hyper, opts) 1; % minimize w.r.t. hyper
mapFcn = @(X_train, Y_train, hyper, opts) mapFcnLogRegASD(X_train, Y_train, hyper, opts);
scoreFcn = @(X_test, Y_test, w, hyper, opts) asd.logLikelihood(Y_test, X_test, w(1:end-1), hyper(2));
scoreFcn = @(X_test, Y_test, w, hyper, opts) reg.rsq(X_test*w(1:end-1) + w(end), Y_test);
minFcn = @(X_train, Y_train, hyper, opts) minFcnLogRegASD(X_train, Y_train, hyper, opts);

%% cross-validate

% score all hyperparameters
opts = struct('D', D);
scores = reg.scoreCVGrid(X_train, Y_train, X_test, Y_test, mapFcn, scoreFcn, nfolds, hypergrid, opts);

% find top-performing hyperparameters over all folds
mean_scores = mean(scores,2);
top_scores_idx = mean_scores > prctile(mean_scores, 99);
top_hypers = hypergrid(top_scores_idx,:);

%% minimize

top_scores = reg.scoreCVGrid(X_train, Y_train, X_test, Y_test, minFcn, scoreFcn, nfolds, top_hypers, opts);

[mx, idx] = max(mean(top_scores,2));
hyper = top_hypers(idx, :);
disp(['top mean score = ' num2str(mx) ' at hyper = ' num2str(hyper)]);
