function mu = calcMAP(X, Y, hyper, Ds)
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    Reg = asd.prior(ro, Ds, deltas);
    [RegInv, B] = asd.invPrior(Reg);
    XB = X*B;
    [mu, ~] = tools.meanInvCov(XB'*XB, XB'*Y, RegInv, ssq);
    mu = B*mu; % map back to original basis
end
