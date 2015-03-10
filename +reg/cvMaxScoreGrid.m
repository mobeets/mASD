function obj = cvMaxScoreGrid(X, Y, hypergrid, fitFcn, fitFcnOpts, ...
    scFcn, scFcnOpts, foldinds)
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
% 

    [X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(X, Y, ...
        nan, foldinds);
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
