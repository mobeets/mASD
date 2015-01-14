function [evi, nll] = scores(X0, Y0, X1, Y1, Ds, hyper)
    evi = asd.gauss.logEvidence(X0, Y0, X0'*X0, X0'*Y0, Ds, hyper);
    nll = -asd.gauss.logLikelihood(X1, Y1, Ds, hyper);
end
