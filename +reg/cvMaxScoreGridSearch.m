function obj = cvMaxScoreGridSearch(data, lbs, ubs, ns, fitFcn,...
    fitFcnOpts, scFcn, scFcnOpts, foldinds, isLog)
% function obj = cvMaxScoreGridSearch(data, lbs, ubs, ns, fitFcn,...
%     fitFcnOpts, scFcn, scFcnOpts, foldinds, isLog)
% 
% fit and plot estimates on data, with cross-validation, by searching
%   through hyperparameter space using gridding and zooming
% 
% data - struct of full data
%   data.X
%   data.Y
%   data.Xxy
%   data.ns
%   data.nt
% lbs, ubs, ns - bounds and bins hyperparameter space
% fitFcn - for generating a fit given training data
% scFcn - for evaluating goodness of fit on testing data
% fitFcnOpts, scFcnOpts - optional arguments passed to respective functions
% foldinds - cross-validation fold indices
% isLog - specifies whether hyperparameter space is log-transformed
% 

    [X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(data.X, ...
        data.Y, nan, foldinds);    
    [scores, hypers, mus] = reg.cvScoreGridSearch(X_train, ...
        Y_train, X_test, Y_test, fitFcn, scFcn, lbs, ubs, ns, ...
        fitFcnOpts, scFcnOpts, isLog);
    
    obj.scores = scores;
    obj.hyper = hypers; % this is now nfolds long
    obj.mus = mus;
end
