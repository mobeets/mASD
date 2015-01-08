function v = logEvidenceSVD(X, Y, YY, Reg, ssq, tol)
%
% calculate log-evidence in basis defined by eigenvalues of Reg > tol*S[0]
%     where S[0] is largest eigenvalue
% i.e., if Reg is m x m and only k of Reg's eigenvalues meet this criteria,
%     this function uses the rank-k approximation of Reg
%
    if nargin < 6
        tol = 1e-8;
    end
    [U, s, ~] = svd(Reg);
    s = diag(s);
    inds = s/s(1) > tol;
    disp(['SVD removed ' num2str(sum(inds)) ' of ' num2str(numel(inds))]);
    RegInv = diag(1/s(inds));
    B = U(:,inds);
    XB = X*B;
    [p2, q2] = size(XB);
    XBXB = XB'*XB;
    XBY = XB'*Y;
    SigmaInv = tools.postCovInv(RegInv, XBXB, ssq);
    v = asd.logEvidence(XBXB, YY, XBY, diag(s(inds)), SigmaInv, ssq, p2, q2);
end
