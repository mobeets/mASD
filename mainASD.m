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
mapFcn = @(X_train, Y_train, hyper, opts) asd.objfcn.gaussASD_MAP(X_train, Y_train, hyper, opts);
minFcn = @(X_train, Y_train, hyper, opts) asd.objfcn.gaussASD_minLogEvi(X_train, Y_train, hyper, opts);
llFcn = @(X_test, Y_test, w, hyper, opts) asd.gaussLogLikelihood(Y_test, X_test, w(1:end-1), hyper(2));
rsqFcn = @(X_test, Y_test, w, hyper, opts) reg.rsq(X_test*w(1:end-1) + w(end), Y_test);
scoreFcn = rsqFcn;

%% search to find best hyperparameters

% score all hyperparameters
opts = struct('D', D, 'fitIntercept', true);
scores = reg.scoreCVGrid(X_train, Y_train, X_test, Y_test, mapFcn, ...
    scoreFcn, nfolds, hypergrid, opts);

% find top-performing hyperparameters over all folds
mean_scores = mean(scores,2);
top_scores_idx = mean_scores > prctile(mean_scores, 99);
top_hypers = hypergrid(top_scores_idx,:);

%% minimize obj starting at best hyperparameters

[new_scores, new_hypers] = reg.scoreCVGrid(X_train, Y_train, X_test, ...
    Y_test, minFcn, scoreFcn, nfolds, top_hypers, opts);
[mx, idx] = max(mean(new_scores,2));
% should I check for where new_scores doesn't beat the previous top_scores?
hyper = new_hypers(idx, :);
disp(['top mean score = ' num2str(mx) ' at hyper = ' num2str(hyper)]);

%% plot

mus = cell(nfolds, 1);
for ii = 1:nfolds
    [mu, b, ~] = mapFcn(X_train{ii}, Y_train{ii}, hyper, opts);
    mus{ii} = mu;
    sc = scoreFcn(X_test{ii}, Y_test{ii}, [mu; b], hyper, opts);
    disp(num2str([ii, sc]));
    wf = reshape(mus{ii}, ns, nt);
    plot.plotKernel(Xxy, wf, nan, nan, nan, ['ASD fold #', num2str(ii)]);
end

trainPct = 0.8;
[Xtr, Ytr, Xte, Yte] = reg.trainAndTest(X, Y, trainPct);
[mu, b, ~] = mapFcn(Xtr, Ytr, hyper, opts);
sc = scoreFcn(Xte, Yte, [mu; b], hyper, opts);
wf = reshape(mu, ns, nt);
plot.plotKernel(Xxy, wf, nan, nan, nan, 'ASD');
