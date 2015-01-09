function [mu, b, hyper] = minFcnLogRegASD(X_train, Y_train, hyper0, opts)
    fitIntercept = true;
    [X, Y, X_mean, Y_mean] = reg.centerData(X_train, Y_train, fitIntercept);
    [mu, ~, hyper] = asd.asd(X, Y, opts.D, hyper0, true, false);
    b = reg.setIntercept(X_mean, Y_mean, mu, fitIntercept);
end
