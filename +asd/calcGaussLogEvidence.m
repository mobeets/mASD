function v = calcGaussLogEvidence(X, Y, Ds, hyper)
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    [XX, XY, YY, p, q, Reg] = asd.gaussInit(X, Y, Ds, hyper);
    RegInv = Reg \ eye(q);
    SigmaInv = tools.postCovInv(RegInv, XX, ssq);
    v = asd.gaussLogEvidence(XX, YY, XY, Reg, SigmaInv, ssq, p, q);
end