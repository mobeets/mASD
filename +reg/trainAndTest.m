function [X0, X1, Y0, Y1] = trainAndTest(X, Y, trainPct)
% X is size [ny, ns]
% Y is size [ny 1]
% returns training and testing sets for X and Y
% 
    ny = numel(Y);
    [trn, tst] = crossvalind('HoldOut', ones(ny, 1), 1-trainPct);
    X0 = X(trn,:);
    X1 = X(tst,:);
    Y0 = Y(trn,:);
    Y1 = Y(tst,:);
end
