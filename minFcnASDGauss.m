function [mu, b, hyper] = minFcnASDGauss(X, Y, hyper0, opts)
% given a starting hyperparameter, find the hyperparameter and kernel
%   that maximizes the evidence (numerically)
    [X, Y, X_mean, Y_mean] = reg.centerData(X, Y, opts.fitIntercept);
    [mu, ~, hyper] = asd.asd(X, Y, opts.D, hyper0, true, false);
    b = reg.setIntercept(X_mean, Y_mean, mu, opts.fitIntercept);
end
