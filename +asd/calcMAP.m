function mu = calcMAP(X, Y, Ds, hyper)
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    [XX, XY, YY, p, q, Reg] = asd.init(X, Y, Ds, hyper);
    [mu, ~] = tools.meanInvCov(XX, XY, Reg, ssq);
end
