function v = sse(Y, X, mu)
    t = Y - X*mu;
    v = t'*t;
end
