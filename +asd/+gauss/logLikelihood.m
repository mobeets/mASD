function v = logLikelihood(Y, X, mu, ssq)
    v = -tools.sse(Y, X, mu)/(2.0*ssq) - size(Y,1)*log(2*pi*ssq)/2.0;
end
