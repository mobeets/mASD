function v = calcLogEvidence(X, Y, Ds, hyper)
    [~, ssq, ~] = asd.unpackHyper(hyper);
    [XX, XY, YY, p, q, Reg] = asd.gauss.init(X, Y, Ds, hyper);
    v = asd.gauss.logEvidence(X, Y, XX, YY, XY, Reg, ssq, p, q);
end