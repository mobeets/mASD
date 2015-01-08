function [Mu, SigmaInv] = meanInvCov(XX, XY, Reg, ssq)
    RegInv = Reg \ eye(size(Reg, 1));
    SigmaInv = reg.postCovInv(RegInv, XX, ssq);
    Mu = reg.postMean(SigmaInv, XY, ssq);
end
