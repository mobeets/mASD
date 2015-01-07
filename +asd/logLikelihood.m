function v = logLikelihood(Y, X, mu, ssq)
    v = -reg.sse(Y, X, mu)/(2.0*ssq) - log(2*pi*ssq)/2.0;
end
