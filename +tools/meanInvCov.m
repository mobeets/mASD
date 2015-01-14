function [mu, sigmaInv] = meanInvCov(XX, XY, RegInv, ssq)
    sigmaInv = tools.postCovInv(RegInv, XX, ssq);
    mu = tools.postMean(sigmaInv, XY, ssq);
end
