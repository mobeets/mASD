function wML = calcGaussML_Ridge(X, Y, rho)
    if numel(rho) > 1
        ssq = rho(2);
        rho = rho(1);
    else
        ssq = 1;
    end
    
    d = size(X,2);
    RegInv = ml.ridgeInvPrior(rho, d);
    wML = tools.meanInvCov(X'*X, X'*Y, RegInv, ssq);
end
