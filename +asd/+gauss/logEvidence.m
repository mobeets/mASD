function [logEvi, sigmaInv, B, isNewBasis] = logEvidence(X, Y, XX, YY, XY, Reg, ssq, p, q)
% 
% XX is X.T.dot(X) - m x m
% YY is Y.T.dot(Y) - 1 x 1
% XY is X.T.dot(Y) - m x 1
% 
    [RegInv, B, isNewBasis] = asd.invPrior(Reg);
    if isNewBasis
        q2 = size(B, 2);
        XB = X*B;
        XBXB = XB'*XB;
        sigmaInv = tools.postCovInv(RegInv, XBXB, ssq);
        RegB = diag(1./diag(RegInv));
        logEvi = safeLogEvidence(XBXB, YY, XB'*Y, RegB, sigmaInv, ssq, p, q2);
    else
        sigmaInv = tools.postCovInv(RegInv, XX, ssq);
        logEvi = safeLogEvidence(XX, YY, XY, Reg, sigmaInv, ssq, p, q);
    end
end

function v = safeLogEvidence(XX, YY, XY, Reg, sigmaInv, ssq, p, q)
% 
% XX is X.T.dot(X) - m x m
% YY is Y.T.dot(Y) - 1 x 1
% XY is X.T.dot(Y) - m x 1
% 
    A = -tools.logdet((Reg*XX)/ssq + eye(q)) - p*log(2*pi*ssq);
    B = YY/ssq - (XY' * (sigmaInv \ XY))/(ssq^2); % linv
    v = (A - B)/2.0;
end
