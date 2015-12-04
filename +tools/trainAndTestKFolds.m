function [trials, inds] = trainAndTestKFolds(X, Y, nfolds, inds)
% function [X_train, Y_train, X_test, Y_test, inds] = trainAndTestKFolds(...
%     X, Y, nfolds, inds)
% 
% returns training and testing sets for X and Y, as cell array
%   e.g. X_train{1} returns first training set for X
% 
% X - 1d or 2d, size [ny ?]
% Y - 1d or 2d, size [ny ?]
% nfolds - # of folds to generate
% inds - fold assignments for rows of X and Y
% 
    if nargin < 4 || all(isnan(inds))
        ny = numel(Y);
        inds = tools.crossvalind('Kfold', ny, nfolds);
    else
        nfolds = max(inds);
    end
    X_train = cell(nfolds, 1);
    X_test = cell(nfolds, 1);
    Y_train = cell(nfolds, 1);
    Y_test = cell(nfolds, 1);
    for ii = 1:nfolds
        idx = (inds == ii);
        X_train{ii} = X(~idx,:,:);
        X_test{ii} = X(idx,:,:);
        Y_train{ii} = Y(~idx,:);
        Y_test{ii} = Y(idx,:);
    end
    trials = struct('x_train', X_train, 'y_train', Y_train, ...
        'x_test', X_test, 'y_test', Y_test);
end
