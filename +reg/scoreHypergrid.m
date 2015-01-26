function obj = scoreHypergrid(data, hypergrid, fitFcn, fitFcnOpts, scFcn, scFcnOpts, foldinds, lbl, ifold)
% 
% fit and plot estimates on data, with cross-validation
% 
% data - struct
%   data.X
%   data.Y
%   data.Xxy
%   data.ns
%   data.nt
% 
% hypergrid - grid of hyperparameters to test M.mapFcn on
% nfolds - # of folds in cross-validation
% ifold - fold to use for generating ASD figure
% 

    [X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(data.X, data.Y, nan, foldinds);
    obj = reg.cvFitAndScore(X_train, Y_train, ...
        X_test, Y_test, hypergrid, fitFcn, scFcn, fitFcnOpts, scFcnOpts);
    sc = obj.scores(ifold); wf = obj.mus{ifold};
    obj.fig = plot.prepAndPlotKernel(data.Xxy, wf, data.ns, data.nt, ifold, lbl, sc);
    obj.foldinds = foldinds;
    obj.label = lbl; 
end
