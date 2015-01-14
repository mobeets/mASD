function v = calcLogLikelihood(X, Y, Ds, hyper)
    [~, ssq, ~] = asd.unpackHyper(hyper);
    mu = asd.gauss.calcMAP(X, Y, hyper, Ds);
    v = asd.gauss.logLikelihood(Y, X, mu, ssq);
end
