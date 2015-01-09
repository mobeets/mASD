function [mu, b, hyper] = mapFcnASDGauss(X, Y, hyper, opts)
% given a hyperparameter, calculate the MAP estimate
%   with gaussian likelihood (closed form)
    [X, Y, X_mean, Y_mean] = reg.centerData(X, Y, opts.fitIntercept);
    mu = asd.calcMAP(X, Y, opts.D, hyper);
    b = reg.setIntercept(X_mean, Y_mean, mu, opts.fitIntercept);
end
