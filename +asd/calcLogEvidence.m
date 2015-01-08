function v = calcLogEvidence(X, Y, Ds, hyper)
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    [XX, XY, YY, p, q, Reg] = asd.init(X, Y, Ds, hyper);
    RegInv = Reg \ eye(q);
    SigmaInv = reg.postCovInv(RegInv, XX, ssq);
    v = asd.logEvidence(XX, YY, XY, Reg, SigmaInv, ssq, p, q);
end