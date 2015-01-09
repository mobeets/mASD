function [X_train, Y_train, X_test, Y_test] = trainAndTestKFolds(X, Y, nfolds)
% returns training and testing sets for X and Y, as cell array
%   e.g. X_train{1} returns first training set for X
% 
% X is 1d or 2d, size [ny ?]
% Y is 1d or 2d, size [ny ?]
% 
    ny = numel(Y);
    inds = crossvalind('Kfold', ny, nfolds);
    X_train = cell(nfolds, 1);
    X_test = cell(nfolds, 1);
    Y_train = cell(nfolds, 1);
    Y_test = cell(nfolds, 1);
    for ii = 1:nfolds
        idx = (inds == ii);
        X_train{ii} = X(~idx,:);
        X_test{ii} = X(idx,:);
        Y_train{ii} = Y(~idx,:);
        Y_test{ii} = Y(idx,:);
    end
end
