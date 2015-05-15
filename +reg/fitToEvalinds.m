function obj = fitToEvalinds(X, Y, evalinds, fitFcn, scoreFcn, hyper)
% 
% X, Y - full data to fit
% hyper - hyperparameter to use for generating fits
% fitFcn - for generating a fit given training data
% scoreFcn - for evaluating goodness of fit on testing data
% evalinds - development/evaluation set indices
% 
    % split X, Y into development/evaluation sets    
    evaltrials = reg.trainAndTest(X, Y, nan, evalinds);
    obj.hyper = hyper;
    obj.scores = [];
    obj = reg.cvFitAndEvaluateHyperparam(obj, evaltrials, ...
        fitFcn, scoreFcn);
end
