%%
load('data/XY.mat', 'X', 'Y', 'Xxy', 'R');
[ny, nt, ns] = size(X);
X_OG = permute(X, [1 3 2]);
X = reshape(X_OG, ny, nt*ns);
D = tools.sqdistSpaceTime(Xxy, ns, nt);

%% init

% grid hyperparameters
ndeltas = 2;
hypergrid = asd.makeHyperGrid(nan, nan, nan, ndeltas, false, false);

% create k-fold cross-validation data
nfolds = 10;
[X_train, R_train, X_test, R_test] = reg.trainAndTestKFolds(X, R, nfolds);

% make objective and score functions
mapFcn = @(X_train, R_train, hyper, opts) asd.objfcn.bernASD_MAP(X_train, R_train, hyper, opts);
scoreFcn = @(X_test, R_test, w, hyper, opts) -tools.neglogli_bernoulliGLM(w(1:end-1), X_test, R_test);
rsqFcn = @(X_test, R_test, w, hyper, opts) reg.rsq(tools.logistic(X_test*w(1:end-1) + w(end)), R_test);

%% search to find best hyperparameters

% score all hyperparameters
opts = struct('D', D, 'fitIntercept', true, 'isLog', true);
[scores, ~, mus] = reg.scoreCVGrid(X_train, R_train, X_test, R_test, mapFcn, ...
    scoreFcn, nfolds, hypergrid, opts);

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
    sc = rsqFcn(X_test{ii}, R_test{ii}, mu{ii}, hypers, opts);
%     sc = scs(ii);
    scstr = sprintf('%.2f', sc);
    disp([num2str(ii) ' - '  scstr]);
    plot.plotKernel(Xxy, wf, nan, nan, nan, ['ASD f', num2str(ii) ' sc=' num2str(scstr)]);
end

%% ML

fitIntercept = true;
mus_ML = cell(nfolds,1);
for ii = 1:nfolds
    Xtr = X_train{ii};
    Xte = X_test{ii};
    Rtr = R_train{ii};
    Rte = R_test{ii};
    [Xtr, Rtr, Xtr_mean, Rtr_mean] = reg.centerData(Xtr, Rtr, fitIntercept);
    
    obj = @(w) tools.neglogli_bernoulliGLM(w, Xtr, Rtr);
    objopts = optimset('display', 'off', 'gradobj', 'on', ...
            'largescale', 'off', 'algorithm', 'Active-Set');
    w0 = (Xtr'*Xtr)\(Xtr'*Rtr);
    wMAP = fminunc(obj, w0, objopts);
    b = reg.setIntercept(Xtr_mean, Rtr_mean, wMAP, fitIntercept);
    wMAP = [wMAP; b];
    
    nll = scoreFcn(Xte, Rte, wMAP, nan, nan);
    rsq = rsqFcn(Xte, Rte, wMAP, nan, nan);
    disp(num2str([ii, nll, rsq]));
    
    mus_ML{ii} = wMAP;
    wf = reshape(wMAP(1:end-1), ns, nt);
    scstr = sprintf('%.2f', rsq);
%     plot.plotKernel(Xxy, wf, nan, nan, nan, ['ASD f', num2str(ii) ' sc=' num2str(scstr)]);
end
