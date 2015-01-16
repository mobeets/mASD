function fit = cvFitAndScore(X_train, Y_train, X_test, Y_test, hypergrid, fitFcn, scFcn, fitFcnOpts, scFcnOpts)
% 
% for each fold, find the best weights on training data
%   (by searching through a grid of hyperparameters)
% then score the resulting fit on test data.
% 
    [scores, ~, mus] = reg.scoreCVGrid(X_train, Y_train, X_test, ...
        Y_test, fitFcn, scFcn, hypergrid, fitFcnOpts, scFcnOpts);
    nfolds = size(scores,2);
    mean_scores = mean(scores,2);
    [~, idx] = max(mean_scores);
    hyper = hypergrid(idx,:);
    scs = scores(idx,:);    
    mu = cell(nfolds,1);
    [mu{:}] = mus{idx,:};
    
    fit.hyper = hyper;
    fit.scores = scs;
    fit.mus = mu;
end
