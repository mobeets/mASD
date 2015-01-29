function [scores, hypers, mus] = cvScoreGrid(X_train, Y_train, X_test, Y_test, mapFcn, scoreFcn, hypergrid, map_opts, score_opts)
% solves for kernel w s.t. Y=Xw for hyperparameters in hypergrid
%   using cross-validation
% 
% X_train, X_test [cells] - training and testing stimuli
% Y_train, Y_test [cells] - training and testing responses
% mapFcn(X, Y, hyper, opts) [function handle]
%   - returns MAP estimate of w for Y=Xw given a hyperparameter
%   - also returns DC term, or offset
%   - also returns hyper, if changed
% scoreFcn(X, Y, w, hyper, opts) [function handle]
%   - evaluates the test score (e.g. test likelihood) of w s.t. Y=Xw
% nfolds [numeric] - # of folds in cross-validation
% hypergrid [matrix] - hyperparameters to score for each fold of cv
% map_opts [struct] - optional data passed to scoreFcn
% score_opts [struct] - optional data passed to scoreFcn
% 
% returns matrix of scores for each fold for each hyperparameter
%   also returns matrix of hypers corresponding to scores
% 
    nfolds = numel(X_train);
    nhypers = size(hypergrid, 1);
    nhyperdims = size(hypergrid, 2);
    scores = nan(nhypers, nfolds);
    hypers = nan(nhypers, nfolds, nhyperdims);
    mus = cell(nhypers, nfolds);
    for ii = 1:nfolds
        disp(['FOLD #' num2str(ii) ' of ' num2str(nfolds)]);
        x_train = X_train{ii};
        x_test = X_test{ii};
        y_train = Y_train{ii};
        y_test = Y_test{ii};
        for jj = 1:nhypers
            if mod(jj, round(nhypers/5)) == 0
                disp(['HYPER #' num2str(jj) ' of ' num2str(nhypers)]);
            end
            hyper0 = hypergrid(jj,:);
            [w, b, hyper] = reg.fitHypersAndWeights(x_train, y_train, mapFcn(hyper0, map_opts{:}));
            mu = [w; b];
            mus{jj, ii} = mu;
            hypers(jj, ii, :) = hyper; % may be unchanged from hyper0
            scores(jj, ii) = scoreFcn(x_test, y_test, mu, hyper, score_opts{:});
        end
    end
end
