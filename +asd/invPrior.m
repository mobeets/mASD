function [RegInv, B] = invPrior(C)
% returns the inverse prior covariance matrix
%   using SVD trick if necessary, returning the new basis
% C [n x n] - prior covariance matrix
% 
    [~, isNotPosDef] = chol(C);
    if isNotPosDef
        % svd trick
        tol = 1e-8;
        [U, s, ~] = svd(C);
        s = diag(s);
        inds = s/s(1) > tol;
        % disp(['SVD removed ' num2str(sum(inds)) ' of ' num2str(numel(inds))]);
        RegInv = diag(1/s(inds));
        B = U(:,inds);
    else
        % no trick
        q = eye(size(C,1));
        RegInv = C\q;
        B = q;
    end
end
