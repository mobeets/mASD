function mu = calcGaussMAP(X, Y, Ds, hyper)
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    [XX, XY, YY, p, q, Reg] = asd.gaussInit(X, Y, Ds, hyper);
    [mu, ~] = tools.meanInvCov(XX, XY, Reg, ssq);
end
