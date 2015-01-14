function [mu, b, hyper] = gaussASD_MAP(X, Y, hyper, opts)
% given a hyperparameter, calculate the MAP estimate
%   with gaussian likelihood (closed form)
    [X, Y, X_mean, Y_mean] = reg.centerData(X, Y, opts.fitIntercept);
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    Reg = asd.prior(ro, opts.D, deltas);
    mu = asd.calcGaussMAP(X, Y, ssq, Reg);
    b = reg.setIntercept(X_mean, Y_mean, mu, opts.fitIntercept);
end
