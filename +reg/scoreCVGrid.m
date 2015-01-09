function [scores, hypers] = scoreCVGrid(X_train, Y_train, X_test, Y_test, mapFcn, scoreFcn, nfolds, hypergrid, opts)
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
% opts [struct] - optional data passed to mapFcn and scoreFcn
% 
% returns matrix of scores for each fold for each hyperparameter
%   also returns matrix of hypers corresponding to scores
% 
    nhypers = size(hypergrid, 1);
    nhyperdims = size(hypergrid, 2);
    scores = nan(nhypers, nfolds);
    hypers = nan(nhypers, nfolds, nhyperdims);
    for ii = 1:nfolds
        x_train = X_train{ii};
        x_test = X_test{ii};
        y_train = Y_train{ii};
        y_test = Y_test{ii};
        for jj = 1:nhypers
%             disp(num2str([ii, jj, nfolds, nhypers]));
            hyper0 = hypergrid(jj,:);
%             disp('running');
            [w, b, hyper] = mapFcn(x_train, y_train, hyper0, opts);
            ws = [w; b];
            hypers(jj, ii, :) = hyper; % may be unchanged from hyper0
%             disp('scoring');
            scores(jj, ii) = scoreFcn(x_test, y_test, ws, hyper, opts);
        end
    end
end
