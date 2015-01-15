%% load

[X, Y_all, R, D, Xxy, nt, ns] = loadData('data/XY.mat');
ndeltas = size(D, 3);
nfolds = 7;
Y = Y_all(:,10); % choose 10th cell for analysis

%% init

% create k-fold cross-validation data
[X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(X, Y, nfolds);

% make objective and score functions
mapFcn = @asd.gauss.fitMAP;
minFcn = @asd.gauss.fitMinNegLogEvi;
llFcn = @(X_test, Y_test, w, hyper) asd.gauss.logLikelihood(Y_test, X_test, w, hyper(2));
rsqFcn = @(X_test, Y_test, w, hyper) reg.rsq(X_test*w(1:end-1) + w(end), Y_test);

%% search to find best hyperparameters

% make hyperparameter grid
hypergrid = asd.makeHyperGrid(nan, nan, nan, ndeltas, false);

% score all hyperparameters
fcn_opts = {D};
scores = reg.scoreCVGrid(X_train, Y_train, X_test, Y_test, mapFcn, ...
    rsqFcn, nfolds, hypergrid, fcn_opts, {});

% find top-performing hyperparameters over all folds
mean_scores = mean(scores,2);
[mx0, idx0] = max(mean_scores);
top_scores_idx = mean_scores > prctile(mean_scores, 99);
top_hypers = hypergrid(top_scores_idx,:);

%% minimize obj starting at best hyperparameters

[new_scores, new_hypers] = reg.scoreCVGrid(X_train, Y_train, X_test, ...
    Y_test, minFcn, llFcn, nfolds, top_hypers, fcn_opts, {});
new_mean_scores = mean(new_scores,2);
[mx, idx] = max(new_mean_scores);
%%
mx = -inf;
if mx0 > mx
    hyper = hypergrid(idx0,:);
    mxa = mx0;
    disp('n.b. most recent optimization was outperformed by original one.');
else
    hyper = top_hypers(idx,:);
    mxa = mx;
end
disp(['top mean score = ' num2str(mxa) ' at hyper = ' num2str(hyper)]);

%% plot

mus = cell(nfolds, 1);
for ii = 1:nfolds
    [mu, b, ~] = mapFcn(X_train{ii}, Y_train{ii}, hyper, D);
    mus{ii} = mu;
    sc = rsqFcn(X_test{ii}, Y_test{ii}, [mu; b], hyper);
    scstr = sprintf('%.2f', sc);
    disp([num2str(ii) ' - '  scstr]);
    wf = reshape(mus{ii}, ns, nt);
    plot.plotKernel(Xxy, wf, nan, nan, nan, ['ASD f', num2str(ii) ' sc=' num2str(scstr)]);
end

trainPct = 0.8;
[Xtr, Ytr, Xte, Yte] = reg.trainAndTest(X, Y, trainPct);
[mu, b, ~] = mapFcn(Xtr, Ytr, hyper, D);
sc = rsqFcn(Xte, Yte, [mu; b], hyper);
wf = reshape(mu, ns, nt);
plot.plotKernel(Xxy, wf, nan, nan, nan, 'ASD');

%% fixed hyper

hyper_rsq = [4.4817    2.7183    0.2865   12.1825];
% hyper_ll = [0.0498   54.5982   12.1825 22026.0];
hyper_rsq = [1.0000   54.5982    0.2865   12.1825];
hyper_ll = [0.0498   54.5982    0.2865   12.1825];

%% OLS

mus_ML = cell(nfolds,1);
for ii = 1:nfolds
    Xtr = X_train{ii};
    Xte = X_test{ii};
    Ytr = Y_train{ii};
    Yte = Y_test{ii};
    [wML, b, ~] = ml.fitGaussML(Xtr, Ytr);
    wML = [wML; b];
    
    rsq = rsqFcn(Xte, Yte, wML, nan);
    scstr = sprintf('%.2f', rsq);
    disp([num2str(ii) ' - '  scstr]);
    
    wf = reshape(wML(1:end-1), ns, nt);
    plot.plotKernel(Xxy, wf, nan, nan, nan, ['ML f', num2str(ii) ' sc=' num2str(scstr)]);
end
