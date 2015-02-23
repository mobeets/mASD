function obj = cvMaxScoreGridSearch(data, lbs, ubs, ns, fitFcn, fitFcnOpts, scFcn, scFcnOpts, foldinds, isLog)
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
% isLog - if lbs, ubs are in logspace
% 

    [X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(data.X, ...
        data.Y, nan, foldinds);    
    [scores, hypers, mus] = reg.cvScoreGridSearch(X_train, ...
        Y_train, X_test, Y_test, fitFcn, scFcn, lbs, ubs, ns, fitFcnOpts, ...
        scFcnOpts, isLog);
    
    obj.scores = scores;
    obj.hyper = hypers; % this is now nfolds long
    obj.mus = mus;
end