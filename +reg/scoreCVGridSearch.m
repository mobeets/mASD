function [scores, hypers, mus] = scoreCVGridSearch(X_train, Y_train, X_test, Y_test, mapFcn, scoreFcn, lbs, ubs, ns, map_opts, score_opts)
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
% 
% returns matrix of scores for each fold for each hyperparameter
%   also returns matrix of hypers corresponding to scores
% 
    nfolds = numel(X_train);
    nhypers = numel(lbs);
    scores = cell(nfolds,1);
    hypers = cell(nfolds,1);
    mus = cell(nfolds,1);
    
    gs = @(fcn) reg.gridSearch(lbs, ubs, ns, 1e-5*ones(1,nhypers), 1e-7, 1e4, fcn);
    
    for ii = 1:nfolds
        disp(['FOLD #' num2str(ii) ' of ' num2str(nfolds)]);
        x_train = X_train{ii};
        x_test = X_test{ii};
        y_train = Y_train{ii};
        y_test = Y_test{ii};
        
        g = @(hyper) mapFcnHandle(mapFcn, x_train, y_train, hyper, map_opts);
        f = @(hyper) -scoreFcn(x_test, y_test, g(hyper), hyper, score_opts{:});
        [mxHyper, mxScore] = gs(f);
        
        [w, b, mxHyper] = mapFcn(x_train, y_train, mxHyper, map_opts{:});
        mu = [w; b];
        mus{ii} = mu;
        hypers{ii} = mxHyper;
        scores{ii} = mxScore;
    end
end

function mu = mapFcnHandle(mapFcn, x_train, y_train, hyper0, map_opts)
    [w, b, mxHyper] = mapFcn(x_train, y_train, hyper0, map_opts{:});
    mu = [w; b];
%     f = @(hyper) -scoreFcn(x_test, y_test, mu, myHyper, score_opts{:});
end
