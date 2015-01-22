function obj = runASDandML_grid(data, M, hypergrid, foldinds, ifold)
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
    ASD = reg.cvFitAndScore(X_train, Y_train, ...
        X_test, Y_test, hypergrid, fitFcn, scFcn, fitFcnOpts, {});
    sc = ASD.scores(ifold);
    wf = ASD.mus{ifold};
    ASD.fig = plot.prepAndPlotKernel(data.Xxy, wf, data.ns, data.nt, ifold, 'ASD', sc);
    
    fitFcn = M.mlFcn;
    fitFcnOpts = {};
    ML = reg.cvFitAndScore(X_train, Y_train, ...
        X_test, Y_test, [nan nan nan], fitFcn, scFcn, fitFcnOpts, {});
    sc = ML.scores(1);
    wf = ML.mus{1};
    ML.fig = plot.prepAndPlotKernel(data.Xxy, wf, data.ns, data.nt, 0, 'ML', sc);
    
    obj.ML = ML;
    obj.ASD = ASD;
    obj.foldinds = foldinds;
    
end
