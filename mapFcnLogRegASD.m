function [mu, b, hyper] = mapFcnLogRegASD(X_train, Y_train, hyper, opts)
    fitIntercept = true;
    D = opts.D;
    ssq = hyper(2);
    [X, Y, X_mean, Y_mean] = reg.centerData(X_train, Y_train, fitIntercept);
    [XX, XY, YY, p, q, Reg] = asd.init(X, Y, D, hyper);
    [mu, ~] = tools.meanInvCov(XX, XY, Reg, ssq);
    b = reg.setIntercept(X_mean, Y_mean, mu, fitIntercept);
end
