function obj = cvMaxScoreGridSearch(X, Y, lbs, ubs, ns, fitFcn,...
    fitFcnOpts, scFcn, scFcnOpts, foldinds, evalinds, isLog)
% function obj = cvMaxScoreGridSearch(data, lbs, ubs, ns, fitFcn,...
%     fitFcnOpts, scFcn, scFcnOpts, foldinds, isLog)
% 
% fit and plot estimates on data, with cross-validation, by searching
%   through hyperparameter space using gridding and zooming
% 
% X, Y - full data
% lbs, ubs, ns - bounds and bins hyperparameter space
% fitFcn - for generating a fit given training data
% scFcn - for evaluating goodness of fit on testing data
% fitFcnOpts, scFcnOpts - optional arguments passed to respective functions
% foldinds - cross-validation fold indices
% evalinds - evaluation set indices
% isLog - specifies whether hyperparameter space is log-transformed
% 

    % split X, Y into development/evaluation sets
    evaltrials = reg.trainAndTest(X, Y, nan, evalinds);
    devtrials = reg.trainAndTestKFolds(X, Y, ...
        nan, foldinds);    
    [scores, hypers, mus] = reg.cvScoreGridSearch(devtrials, fitFcn, ...
        scFcn, lbs, ubs, ns, fitFcnOpts, scFcnOpts, isLog);
    
    % todo: once cvScoreGridSearch is fixed, replace the below with:
%     obj = reg.cvSummarizeScores(scores, hypergrid, mus);
%     obj = reg.cvFitAndEvaluateHyperparam(obj, evaltrials, ...
%         fitFcn, fitFcnOpts, scFcn, scFcnOpts);
    
    obj.scores = scores;
    obj.hyper = hypers; % this is now nfolds long
    obj.mus = mus;
    
    % fit on X1, Y1
    % obj.mu = % fit on evaluation set
    % obj.score = % score on evaluation set
    
    obj.muCorrFolds = corrcoef([obj.mus{:}]); % corrcoef of mu across folds
    obj.scoreVarFolds = std(obj.scores); % std dev of scores across folds
end
