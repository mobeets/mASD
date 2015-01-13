function [der_ro, der_ssq, der_deltas] = gaussLogEvidenceGradient(hyper, p, q, Ds, mu, Sigma, Reg, sse)
% 
% gradient of log evidence w.r.t. hyperparameters
% 
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    Z = Reg / (Reg - Sigma - (mu'*mu)); % rinv
    der_ro = trace(Z)/2.0;
    
    v = -p + q - trace(Reg / Sigma); % rinv
    der_ssq = sse/(ssq^2) + v/ssq;

    der_deltas = nan(1, numel(deltas));
    for ii = 1:numel(deltas)
        delta = deltas(ii);
        D = Ds(:,:,ii);
        der_deltas(ii) = -trace(Reg / (Z * Reg * D/(delta^3)))/2.0; % rinv
    end
end
