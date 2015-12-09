function [nlogevi, nderlogevi] = objfcn(hyper, Ds, X, Y, XX, XY, YY, p, q, isLog)
    if isLog
        hyper(2:end) = exp(hyper(2:end));
    end

    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    Reg = asd.prior(ro, Ds, deltas);
    [logEvi, sigmaInv, B, isNewBasis] = asd.gauss.logEvidence(X, Y, XX, ...
        YY, XY, Reg, ssq, p, q);
    nlogevi = -logEvi;
    if nargout > 1
        if isNewBasis
            XY = (X*B)'*Y;
        end
        mu = tools.postMean(sigmaInv, XY, ssq);
        if isNewBasis
            mu = B*mu;
            sigmaInv = B*sigmaInv*B';
        end
        sse = tools.sse(Y, X, mu);
        Sigma = pinv(sigmaInv);
        [der_ro, der_ssq, der_deltas] = asd.gauss.logEvidenceGradient(...
            hyper, p, q, Ds, mu, Sigma, Reg, sse);
        derlogevi = [der_ro, der_ssq, der_deltas];
        nderlogevi = -derlogevi;
%         if isLog
%             nderlogevi(2:end) = -log(derlogevi(2:end));
%         end
    end
end
