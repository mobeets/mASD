%% load

[X, Y_all, R, D, Xxy, nt, ns] = loadData('data/XY.mat');
ndeltas = size(D, 3);
nfolds = 7;

%% init

% create k-fold cross-validation data
[X_train, R_train, X_test, R_test] = reg.trainAndTestKFolds(X, R, nfolds);

% make objective and score functions
mapFcn = @asd.bern.fitMAP;
llFcn = @(X_test, R_test, w, hyper) -tools.neglogli_bernoulliGLM(w(1:end-1), X_test, R_test);
rsqFcn = @(X_test, R_test, w, hyper) reg.rsq(tools.logistic(X_test*w(1:end-1) + w(end)), R_test);

%% search to find best hyperparameters

% make hyperparameter grid
hypergrid = asd.makeHyperGrid(nan, nan, nan, ndeltas, false, false);
% lbs = [-3.5 1 1];
% ubs = [-1 4 4];
% hypergrid = asd.makeHyperGrid(lbs, ubs, nan, ndeltas, false, false);
% lbs = [-4.0 1 2];
% ubs = [-3 2 3];
% hypergrid = asd.makeHyperGrid(lbs, ubs, nan, ndeltas, false, false);

% score all hyperparameters
opts = {D};
[scores, ~, mus] = reg.scoreCVGrid(X_train, R_train, X_test, R_test, mapFcn, ...
    llFcn, hypergrid, opts, {});

% find top-performing hyperparameters over all folds
mean_scores = mean(scores,2);
[hyper_score, idx] = max(mean_scores);
hypers = hypergrid(idx,:);
mu = cell(nfolds,1);
[mu{:}] = mus{idx,:};

%% plot

for ii = 1:nfolds
    wf = mu{ii}; wf = wf(1:end-1); b = wf(end);
    wf = reshape(wf, ns, nt);
    sc = rsqFcn(X_test{ii}, R_test{ii}, mu{ii}, hypers);
    scstr = sprintf('%.2f', sc);
    disp([num2str(ii) ' - '  scstr]);
    plot.plotKernel(Xxy, wf, nan, nan, nan, ['ASD f', num2str(ii) ' sc=' num2str(scstr)]);
end

%% plot fixed hyper

% for both ll and rsq scores, 7 or 10 folds:
hypers = [0.0498   12.1825   12.1825];
hypers2 = [0.0302    5.7546   12.1825];
hypers3 = [0.0183    7.3891    7.3891];
idx = 61;
% hypers1 = [0.08, 10.0, 10.0];
for ii = 1:nfolds
    [mu, b, hyper] = asd.bern.fitMAP(X_train{ii}, R_train{ii}, hypers1, D);
    wf = mu;
    wf = reshape(wf, ns, nt);
    sc = rsqFcn(X_test{ii}, R_test{ii}, [mu; b], hypers);
    scstr = sprintf('%.2f', sc);
    disp([num2str(ii) ' = '  scstr]);
    plot.plotKernel(Xxy, wf, nan, nan, nan, ['ASD f', num2str(ii) ' sc=' num2str(scstr)]);
end
%% ML

mus_ML = cell(nfolds,1);
for ii = 1:nfolds
    Xtr = X_train{ii};
    Xte = X_test{ii};
    Rtr = R_train{ii};
    Rte = R_test{ii};
    [wML, b, ~] = ml.fitBernML(Xtr, Rtr);
    wML = [wML; b];
    
    nll = llFcn(Xte, Rte, wML, nan);
    rsq = rsqFcn(Xte, Rte, wML, nan);
    scstr = sprintf('%.2f', rsq);
    disp([num2str(ii) ' = '  scstr]);
    
    mus_ML{ii} = wML;
    wf = reshape(wML(1:end-1), ns, nt);
    scstr = sprintf('%.2f', rsq);
    plot.plotKernel(Xxy, wf, nan, nan, nan, ['ML f', num2str(ii) ' sc=' num2str(scstr)]);
end
