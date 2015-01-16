function [ASD, ML] = runASDandML(data, M, hypergrid, nfolds, ifold)
% 
% fit and plot ASD and ML estimates on data, with cross-validation
% 
% data - struct
%   data.X
%   data.Y
%   data.Xxy
%   data.ns
%   data.nt
% 
% M - struct
%   M.rsqFcn
%   M.llFcn
%   M.mapFcn
%   M.mlFcn
%   M.mapFcnOpts
% 
% hypergrid - grid of hyperparameters to test M.mapFcn on
% nfolds - # of folds in cross-validation
% ifold - fold to use for generating ASD figure
% 

    scFcn = M.rsqFcn;
    [X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(data.X, data.Y, nfolds);
    
    fitFcn = M.mapFcn;
    fitFcnOpts = M.mapFcnOpts;
    ASD = cvFitAndScore(X_train, Y_train, ...
        X_test, Y_test, hypergrid, fitFcn, scFcn, fitFcnOpts, {});
    sc = ASD.scores(ifold);
    wf = ASD.mus{ifold};
    ASD.fig = prepAndPlotKernel(data.Xxy, wf, data.ns, data.nt, ifold, 'ASD', sc);
    
    fitFcn = M.mlFcn;
    fitFcnOpts = {};
    ML = cvFitAndScore(X_train, Y_train, ...
        X_test, Y_test, [nan nan nan], fitFcn, scFcn, fitFcnOpts, {});
    sc = ML.scores(1);
    wf = ML.mus{1};
    ML.fig = prepAndPlotKernel(data.Xxy, wf, data.ns, data.nt, 0, 'ML', sc);
    
end

function fit = cvFitAndScore(X_train, Y_train, X_test, Y_test, hypergrid, fitFcn, scFcn, fitFcnOpts, scFcnOpts)
% 
% for each fold, find the best weights on training data
%   (by searching through a grid of hyperparameters)
% then score the resulting fit on test data.
% 
    [scores, ~, mus] = reg.scoreCVGrid(X_train, Y_train, X_test, ...
        Y_test, fitFcn, scFcn, hypergrid, fitFcnOpts, scFcnOpts);
    nfolds = size(scores,2);
    mean_scores = mean(scores,2);
    [~, idx] = max(mean_scores);
    hyper = hypergrid(idx,:);
    scs = scores(idx,:);    
    mu = cell(nfolds,1);
    [mu{:}] = mus{idx,:};
    
    fit.hyper = hyper;
    fit.scores = scs;
    fit.mus = mu;
end

function fig = prepAndPlotKernel(Xxy, wf, ns, nt, ifold, lbl, sc)
% plots the spatiotemporal kernel
    wf = wf(1:end-1);
    wf = reshape(wf, ns, nt);
    scstr = sprintf('%.2f', sc);
    title = [lbl ' f', num2str(ifold) ' sc=' num2str(scstr)];
    fig = plot.plotKernel(Xxy, wf, nan, title);
end