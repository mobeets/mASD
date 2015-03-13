function obj = cvMaxScoreGrid(X, Y, hypergrid, fitFcn, fitFcnOpts, ...
    scFcn, scFcnOpts, foldinds, evalinds)
% obj = cvMaxScoreGrid(data, hypergrid, fitFcn, fitFcnOpts, ...
% scFcn, scFcnOpts, foldinds)
% 
% fit and plot estimates on data, with cross-validation, by gridding
%   the hyperparameters and maximizing the test score
% 
% X, Y - full data to fit
% hypergrid - grid of hyperparameters to use for generating fits
% fitFcn - for generating a fit given training data
% scFcn - for evaluating goodness of fit on testing data
% fitFcnOpts, scFcnOpts - optional arguments passed to respective functions
% foldinds - cross-validation fold indices
% evalinds - evaluation set indices
% 

    % split X, Y into development/evaluation sets    
    evaltrials = reg.trainAndTest(X, Y, nan, evalinds);
    
    % find best hyperparameter on development set
    % n.b. development/evaluation sets still overlap, which is dumb, but I
    % don't want to deal with nans in some cells...my bad
    devtrials = reg.trainAndTestKFolds(X, Y, nan, foldinds);
    [scores, ~, mus] = reg.cvScoreGrid(devtrials, fitFcn, scFcn, ...
        hypergrid, fitFcnOpts, scFcnOpts);
    
    % evaluate hyperparameter on evaluation set, and score
    obj = reg.cvSummarizeScores(scores, hypergrid, mus);
    obj = reg.cvFitAndEvaluateHyperparam(obj, evaltrials, fitFcn, ...
        fitFcnOpts, scFcn, scFcnOpts);
end
