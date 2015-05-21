function obj = cvMaxScoreGrid(X, Y, fitFcn, scoreFcn, hypers, foldinds, ...
    evalinds, searchType, hyperOpts)
% obj = cvMaxScoreGrid(data, hypergrid, fitFcn, fitFcnOpts, ...
% scFcn, scFcnOpts, foldinds, evalinds)
% 
% fit and plot estimates on data, with cross-validation, by gridding
%   the hyperparameters and maximizing the test score
% 
% X, Y - full data to fit
% hypers - grid of hyperparameters to use for generating fits
% hyperOpts - hyperparameter ranges
%     lbs, ubs, ns
%     isLog
% fcns.
%     fitFcn - for generating a fit given training data
%     scoreFcn - for evaluating goodness of fit on testing data
%     fitFcnOpts - optional arguments passed to fitFcn
%     scoreFcnOpts - optional arguments passed to scFcn
% foldinds - cross-validation fold indices
% evalinds - development/evaluation set indices
% searchType - either 'grid' or 'grid-search'
% 

    % split X, Y into development/evaluation sets    
    evaltrials = reg.trainAndTest(X, Y, nan, evalinds);
    
    % find best hyperparameter on development set
    % n.b. development/evaluation sets still overlap, which is dumb
    devtrials = reg.trainAndTestKFolds(X, Y, nan, foldinds);

    if strcmpi(searchType, 'grid')
        [scores, ~, mus] = reg.cvScoreGrid(devtrials, fitFcn, scoreFcn, ...
            hypers);
    elseif strcmpi(searchType, 'grid-search')
        [scores, hypers, mus] = reg.cvScoreGridSearch(devtrials, ...
            fitFcn, scoreFcn, hyperOpts);
    end
    
    % evaluate hyperparameter on evaluation set, and score
    obj = reg.cvPickBestHyper(scores, hypers, mus);
    obj = reg.cvFitAndEvaluateHyperparam(obj, evaltrials, ...
        fitFcn, scoreFcn);
end
