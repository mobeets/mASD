function [evi, nll] = gaussScores(X0, Y0, X1, Y1, Ds, hyper)
    evi = asd.calcGaussLogEvidence(X0, Y0, Ds, hyper);
    nll = -asd.calcGaussLogLikelihood(X1, Y1, Ds, hyper);
end
