function v = gaussLogEvidence(XX, YY, XY, Reg, SigmaInv, ssq, p, q)
% 
% XX is X.T.dot(X) - m x m
% YY is Y.T.dot(Y) - 1 x 1
% XY is X.T.dot(Y) - m x 1
% 
    A = -tools.logdet((Reg*XX)/ssq + eye(q)) - p*log(2*pi*ssq);
    B = YY/ssq - (XY' * (SigmaInv \ XY))/(ssq^2); % linv
    v = (A - B)/2.0;
end
