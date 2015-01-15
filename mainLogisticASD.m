%% load

[X, Y_all, R, D, Xxy, nt, ns] = loadData('data/XY.mat');
ndeltas = size(D, 3);
nfolds = 10;

%% init

% create k-fold cross-validation data
[X_train, R_train, X_test, R_test] = reg.trainAndTestKFolds(X, R, nfolds);

% make objective and score functions
mapFcn = @asd.bern.fitMAP;
nllFcn = @(X_test, R_test, w, hyper) -tools.neglogli_bernoulliGLM(w(1:end-1), X_test, R_test);
rsqFcn = @(X_test, R_test, w, hyper) reg.rsq(tools.logistic(X_test*w(1:end-1) + w(end)), R_test);

%% search to find best hyperparameters

% make hyperparameter grid
hypergrid = asd.makeHyperGrid(nan, nan, nan, ndeltas, false, false);

% score all hyperparameters
opts = {D};
[scores, ~, mus] = reg.scoreCVGrid(X_train, R_train, X_test, R_test, mapFcn, ...
    nllFcn, nfolds, hypergrid, opts, {});

% find top-performing hyperparameters over all folds
mean_scores = mean(scores,2);
[hyper_score, idx] = max(mean_scores);
hypers = hypergrid(idx,:);
mu = cell(nfolds,1);
[mu{:}] = mus{idx,:};

%% plot

scs = scores(idx,:)./mean(scores,1);
for ii = 1:nfolds
    wf = mu{ii}; wf = wf(1:end-1); b = wf(end);
    wf = reshape(wf, ns, nt);
    sc = rsqFcn(X_test{ii}, R_test{ii}, mu{ii}, hypers);
%     sc = scs(ii);
    scstr = sprintf('%.2f', sc);
    disp([num2str(ii) ' - '  scstr]);
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
    
    nll = nllFcn(Xte, Rte, wML, nan);
    rsq = rsqFcn(Xte, Rte, wML, nan);
    scstr = sprintf('%.2f', rsq);
    disp([num2str(ii) ' - '  scstr]);
    
    mus_ML{ii} = wML;
    wf = reshape(wML(1:end-1), ns, nt);
    scstr = sprintf('%.2f', rsq);
    plot.plotKernel(Xxy, wf, nan, nan, nan, ['ML f', num2str(ii) ' sc=' num2str(scstr)]);
end
