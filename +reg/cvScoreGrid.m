function [scores, hypers, mus] = cvScoreGrid(trials, fitFcn, scoreFcn, ...
    hypergrid)
% function [scores, hypers, mus] = cvScoreGrid(trials, mapFcn, ...
%   scoreFcn, hypergrid, map_opts, score_opts)
% 
% for each data set in cross-validation folds,
%   for each hyperparameter set in hypergrid,
%      solves for kernel w s.t. Y=X*mu + b
%      and returns the resulting score
% trials.
%   x_train, x_test [cells] - training and testing stimuli
%   y_train, y_test [cells] - training and testing responses
% fitFcn(X, Y, hyper, opts) [function handle]
%   - returns MAP estimate of w for Y=Xw given a hyperparameter
%   - also returns DC term, or offset
%   - also returns hyper, if changed
% scoreFcn(X, Y, w, hyper, opts) [function handle]
%   - evaluates the test score (e.g. test likelihood) of w s.t. Y=Xw
% hypergrid [matrix] - hyperparameters to score for each fold of cv
% 
% returns matrix of scores for each fold for each hyperparameter
%   also returns matrix of hypers corresponding to scores
% 
    nfolds = numel(trials);
    nhypers = size(hypergrid, 1);
    nhyperdims = size(hypergrid, 2);
    scores = nan(nhypers, nfolds);
    hypers = nan(nhypers, nfolds, nhyperdims);
    mus = cell(nhypers, nfolds);
    for ii = 1:nfolds
%         disp(['FOLD #' num2str(ii) ' of ' num2str(nfolds)]);
        ctrials = trials(ii);
        for jj = 1:nhypers
            if mod(jj, round(nhypers/5)) == 0
                disp(['HYPER #' num2str(jj) ' of ' num2str(nhypers)]);
            end
            hyper0 = hypergrid(jj,:);
            [w, b, hyper] = reg.fitHypersAndWeights(ctrials.x_train, ...
                ctrials.y_train, fitFcn(hyper0));
            mu = [w; b];
            mus{jj, ii} = mu;
            hypers(jj, ii, :) = hyper; % may be unchanged from hyper0
            scores(jj, ii) = scoreFcn(ctrials, mu, hyper);
        end
    end
end
