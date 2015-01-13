function v = calcGaussLogLikelihood(X, Y, Ds, hyper)
    [~, ssq, ~] = asd.unpackHyper(hyper);
    mu = asd.calcGaussMAP(X, Y, Ds, hyper);
    v = asd.gaussLogLikelihood(Y, X, mu, ssq);
end
