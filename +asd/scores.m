function [evi, nll] = scores(X0, Y0, X1, Y1, Ds, hyper)
    evi = asd.calcLogEvidence(X0, Y0, Ds, hyper);
    nll = -asd.calcLogLikelihood(X1, Y1, Ds, hyper);
end
