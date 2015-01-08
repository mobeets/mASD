function [Mu, SigmaInv] = meanInvCov(XX, XY, Reg, ssq)
    RegInv = Reg \ eye(size(Reg, 1));
    SigmaInv = tools.postCovInv(RegInv, XX, ssq);
    Mu = tools.postMean(SigmaInv, XY, ssq);
end
