function mu = calcGaussMAP(X, Y, ssq, Reg)
    [RegInv, B] = asd.invPrior(Reg);
    XB = X*B;
    [mu, ~] = tools.meanInvCov(XB'*XB, XB'*Y, RegInv, ssq);
    mu = B*mu; % map back to original basis
end
