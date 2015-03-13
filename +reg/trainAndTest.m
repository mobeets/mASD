function [trials, trninds] = trainAndTest(X, Y, trainPct, inds)
% returns training and testing sets for X and Y
% 
% X is 1d or 2d, size [ny ?]
% Y is 1d or 2d, size [ny ?]
% 
    if nargin < 4
        ny = numel(Y);
        [trninds, tstinds] = crossvalind('HoldOut', ones(ny, 1), 1-trainPct);
    else
        trninds = inds;
    end
    X0 = X(trninds,:);
    X1 = X(tstinds,:);
    Y0 = Y(trninds,:);
    Y1 = Y(tstinds,:);
    trials = struct('x_train', X0, 'y_train', Y0, ...
        'x_test', X1, 'y_test', Y1);
end
