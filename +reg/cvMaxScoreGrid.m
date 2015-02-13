function obj = cvMaxScoreGrid(data, hypergrid, fitFcn, fitFcnOpts, scFcn, scFcnOpts, foldinds)
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
    [scores, ~, mus] = reg.cvScoreGrid(X_train, Y_train, X_test, ...
        Y_test, fitFcn, scFcn, hypergrid, fitFcnOpts, scFcnOpts);
    
    nfolds = size(scores,2);
    mean_scores = mean(scores,2);
    [~, idx] = max(mean_scores);
    hyper = hypergrid(idx,:);
    scs = scores(idx,:);    
    mu = cell(nfolds,1);
    [mu{:}] = mus{idx,:};
    
    obj.hyper = hyper;
    obj.scores = scs;
    obj.mus = mu;

end
