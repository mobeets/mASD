function [der_ro, der_ssq, der_deltas] = logEvidenceGradient(hyper, ...
    p, q, Ds, mu, Sigma, Reg, sse)
% 
% gradient of log evidence w.r.t. hyperparameters
% 
    [~, ssq, deltas] = asd.unpackHyper(hyper);
    Z = (Reg - Sigma - (mu'*mu)) / Reg;
    der_ro = 0.5*trace(Z);
    
    v = -p + q - trace(Sigma / Reg);
    der_ssq = sse/(ssq^2) + v/ssq;

    der_deltas = nan(1, numel(deltas));
    for ii = 1:numel(deltas)
        delta = deltas(ii);
        D = Ds(:,:,ii);
        der_deltas(ii) = -0.5*trace(Z * (Reg .* D/(delta^3)) / Reg);
    end
end
