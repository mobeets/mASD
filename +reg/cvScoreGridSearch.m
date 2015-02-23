function [scores, hypers, mus] = cvScoreGridSearch(X_train, Y_train, X_test, Y_test, mapFcn, scoreFcn, lbs, ubs, ns, map_opts, score_opts, isLog)
% solves for kernel w s.t. Y=Xw for hyperparameters using cross-validation
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
% 
% 
% map_opts [struct] - optional data passed to scoreFcn
% score_opts [struct] - optional data passed to scoreFcn
% isLog [logical] - lbs, ubs are given in logspace, so use exp(hyper)
% 
% returns matrix of scores for each fold for each hyperparameter
%   also returns matrix of hypers corresponding to scores
% 
    nfolds = numel(X_train);
    scores = cell(nfolds,1);
    hypers = cell(nfolds,1);
    mus = cell(nfolds,1);
    
    h = @(x) isLog*exp(x) + (1-isLog)*x;
    
    for ii = 1:nfolds
        disp(['FOLD #' num2str(ii) ' of ' num2str(nfolds)]);
        x_train = X_train{ii};
        x_test = X_test{ii};
        y_train = Y_train{ii};
        y_test = Y_test{ii};
        trials = struct('x_train', x_train, 'y_train', y_train, ...
            'x_test', x_test, 'y_test', y_test);
        
        wts = @(hyper) mapFcnHandle(mapFcn, x_train, y_train, hyper, map_opts);
        score = @(hyper) -scoreFcn(trials, wts(h(hyper)), h(hyper), score_opts{:});
        [mxHyper, mxScore] = reg.gridSearch(score, lbs, ubs, ns);
        
        mxHyper = h(mxHyper); % map back to non-log space, if necessary
        mus{ii} = wts(mxHyper);
        hypers{ii} = mxHyper;
        scores{ii} = -mxScore; % scores are negative, so reverse this
    end
end

function mu = mapFcnHandle(mapFcn, x, y, hyper0, map_opts)
    [w, b, ~] = reg.fitHypersAndWeights(x, y, mapFcn(hyper0, map_opts{:}));
    mu = [w; b];
end
