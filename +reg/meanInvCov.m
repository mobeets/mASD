function [Mu, SigmaInv] = meanInvCov(XX, XY, Reg, ssq)
    SigmaInv = reg.postCovInv(inv(Reg), XX, ssq);
    Mu = reg.postMean(SigmaInv, XY, ssq);
end
