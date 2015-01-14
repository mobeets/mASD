function hyper = optMinNegLogEvi(X, Y, Ds, theta0, isLog, jac)
% 
% X - (p x q) matrix with inputs in rows
% Y - (p, 1) matrix with measurements
% Ds - [(q, q), ...] matrices containing squared distances between all input points
% 
% Implelements the ASD regression descrived in:
%     M. Sahani and J. F. Linden.
%     Evidence optimization techniques for estimating stimulus-response functions.
%     In S. Becker, S. Thrun, and K. Obermayer, eds.
%     Advances in Neural Information Processing Systems, vol. 15, pp. 301-308, Cambridge, MA, 2003
% 
    LOWER_BOUND_DELTA_TEMPORAL = 0.12;
    ndeltas = size(Ds, 3);
    if nargin < 6 || isnan(jac)
        jac = false;
    end
    if nargin < 5 || isnan(isLog)
        isLog = true;
    end
    if nargin < 4 || any(isnan(theta0))
        theta0 = [1.0, 0.15, 2.0*ones(1,ndeltas)];
    end
    if jac
        jacStr = 'on';
    else
        jacStr = 'off';
    end
    if isLog
        theta0 = log(theta0);
        lbs = [-3, -2, -5*ones(1,ndeltas)];
        ubs = [3, 10, 10*ones(1,ndeltas)];
    else
        lbs = [-20, 10e-6, LOWER_BOUND_DELTA_TEMPORAL*ones(1,ndeltas)];
        ubs = [20, 10e6, 1e5*ones(1,ndeltas)];
    end
    [p, q] = size(X);
    YY = Y'*Y;
    XY = X'*Y;
    XX = X'*X;

    % minimize objfcn, with bounds lbs, ubs; starts at theta0
    opts = optimset('display', 'iter', 'gradobj', jacStr, ...
        'largescale', 'off', 'algorithm', 'Active-Set');
    obj = @(hyper) objfcn(hyper, Ds, X, Y, XX, XY, YY, p, q, isLog);
    hyper = fmincon(obj, theta0, [], [], [], [], lbs, ubs, [], opts);
    if isLog
        hyper = exp(hyper);
    end
end

function [nlogevi, nderlogevi] = objfcn(hyper, Ds, X, Y, XX, XY, YY, p, q, isLog)
    if isLog
        hyper = exp(hyper);
    end
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    Reg = asd.prior(ro, Ds, deltas);
    [logEvi, sigmaInv, B, isNewBasis] = asd.gauss.logEvidence(X, Y, XX, YY, XY, Reg, ssq, p, q);
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
        sse =  tools.sse(Y, X, mu);
        Sigma = sigmaInv \ eye(q);
        nderlogevi = -asd.gauss.logEvidenceGradient(hyper, p, q, Ds, mu, Sigma, Reg, sse);
    end
end
