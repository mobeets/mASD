function [scores, hypers, mus] = cvScoreGridSearch(trials, fitFcn, ...
    scoreFcn, hyperOpts)
% function [scores, hypers, mus] = cvScoreGridSearch(trials, mapFcn, ...
% scoreFcn, lbs, ubs, ns, map_opts, score_opts, isLog)
% 
% for each data set in cross-validation folds,
%   solves for kernel w s.t. Y=X*mu + b
%   by choosing the hyperparameter with best prediction accuracy
% 
% trials.
%   x_train, x_test [cells] - training and testing stimuli
%   y_train, y_test [cells] - training and testing responses
% fitFcn(X, Y, hyper, opts) [function handle]
%   - returns MAP estimate of w for Y=Xw given a hyperparameter
%   - also returns DC term, or offset
%   - also returns hyper, if changed
% scoreFcn(X, Y, w, hyper, opts) [function handle]
%   - evaluates the test score (e.g. test likelihood) of w s.t. Y=Xw
% hyperOpts
%     .lbs, .ubs, .ns - specifies bounds and bins of hyperparameter space
%     .isLog [logical] - lbs, ubs are given in logspace, so use exp(hyper)
% 
% returns matrix of scores for each fold for each hyperparameter
%   also returns matrix of hypers corresponding to scores
% 
    h = @(x) hyperOpts.isLog*exp(x) + (1-hyperOpts.isLog)*x;
    getScore = @(hyper) totalScore(hyper, trials, fitFcn, scoreFcn, h);
    [~, ~, hypers, scores] = reg.gridSearch(getScore, ...
        hyperOpts.lbs, hyperOpts.ubs, hyperOpts.ns);
    hypers = h(hypers); % map back to non-log space, if necessary
    scores = -scores;
    mus = [];
end

function score = totalScore(hyper, trials, fitFcn, scoreFcn, h)
% 
    wts = @(hyper, ii) fitFcnHandle(fitFcn, trials(ii).x_train, ...
        trials(ii).y_train, hyper);
    
    nfolds = numel(trials);
    scores = nan(nfolds, 1);
    for ii = 1:nfolds
        scores(ii) = -scoreFcn(trials(ii), wts(h(hyper), ii), h(hyper));
    end
    score = mean(scores);
end

function mu = fitFcnHandle(fitFcn, x, y, hyper0)
    [w, b, ~] = reg.fitHypersAndWeights(x, y, fitFcn(hyper0));
    mu = [w; b];
end
