function obj = runASDandML_GridSearch(data, M, lbs, ubs, ns, foldinds, ifold)
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
    [X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(data.X, data.Y, nan, foldinds);
    
    fitFcn = M.mapFcn;
    fitFcnOpts = M.mapFcnOpts;
    [scores, hypers, mus] = reg.scoreCVGridSearch(X_train, Y_train, X_test, ...
        Y_test, fitFcn, scFcn, lbs, ubs, ns, fitFcnOpts, {});
    ASD.scores = scores;
    ASD.hyper = hypers; % this is now nfolds long
    ASD.mus = mus;
    sc = ASD.scores{ifold};
    wf = ASD.mus{ifold};
    ASD.fig = plot.prepAndPlotKernel(data.Xxy, wf, data.ns, data.nt, ifold, 'ASD', sc);
    
    obj.ASD = ASD;
    obj.foldinds = foldinds;
    
end
