function v = sse(Y, X, mu)
    if size(X,2)+1 == size(mu,1)
        b = mu(end);
        mu = mu(1:end-1);
    else
        b = 0;
    end
    t = Y - (X*mu+b);
    v = t'*t;
end
