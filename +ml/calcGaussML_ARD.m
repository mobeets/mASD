function wML = calcGaussML_ARD(X, Y, rho)
    ssq = rho(end);
    rho = rho(1:end-1);
    
    d = size(X,2);
    assert(numel(rho) == d);
    RegInv = ml.ridgeInvPrior(diag(rho), d);
    wML = tools.meanInvCov(X'*X, X'*Y, RegInv, ssq);
    
%     wML(rho < 1e-3) = 0;
end
