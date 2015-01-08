function [mu, Reg, hyper] = asd(X, Y, Ds, theta0, isLog, jac)
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
    if nargin < 4 || isnan(theta0)
        theta0 = [1.0, 0.15, + 2.0*ones(1,ndeltas)];
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
    opts = optimset('display', 'iter', 'gradobj', 'off', 'largescale', 'off', ...
        'algorithm', 'Active-Set');
    obj = @(hyper) objfcn(hyper, Ds, X, Y, XX, XY, YY, p, q, isLog);
    hyper = fmincon(obj, theta0, [], [], [], [], lbs, ubs, [], opts);
    if isLog
        hyper = exp(hyper);
    end
    disp(hyper);
    [ro, ssq, deltas] = asd.unpackHyper(hyper);

    Reg = asd.prior(ro, Ds, deltas);
    [mu, ~] = reg.meanInvCov(XX, XY, Reg, ssq);
end

function [nlogevi, nderlogevi] = objfcn(hyper, Ds, X, Y, XX, XY, YY, p, q, isLog)
    if isLog
        hyper = exp(hyper);
    end
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    Reg = asd.prior(ro, Ds, deltas);
    [~, isNotPosDef] = chol(Reg);
    if isNotPosDef
        logevi = asd.logEvidenceSVD(X, Y, YY, Reg, ssq); % svd trick
    else
        RegInv = Reg \ eye(q);
        SigmaInv = reg.postCovInv(RegInv, XX, ssq);
        logevi = asd.logEvidence(XX, YY, XY, Reg, SigmaInv, ssq, p, q);
    end
    nlogevi = -logevi;
    if nargout > 1
        mu = reg.postMean(SigmaInv, XY, ssq);
        sse =  reg.sse(Y, X, mu);
        Sigma = SigmaInv \ eye(q);
        nderlogevi = -asd.evidenceGradient(hyper, p, q, Ds, mu, Sigma, Reg, sse);
    end
end
