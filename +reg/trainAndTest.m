function [X0, Y0, X1, Y1] = trainAndTest(X, Y, trainPct)
% returns training and testing sets for X and Y
% 
% X is 1d or 2d, size [ny ?]
% Y is 1d or 2d, size [ny ?]
% 
    ny = numel(Y);
    [trn, tst] = crossvalind('HoldOut', ones(ny, 1), 1-trainPct);
    X0 = X(trn,:);
    X1 = X(tst,:);
    Y0 = Y(trn,:);
    Y1 = Y(tst,:);
end
