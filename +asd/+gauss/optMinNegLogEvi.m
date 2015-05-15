function hyper = optMinNegLogEvi(X, Y, Ds, theta0, isLog, jac, ...
    noDeltaT, nRepeats)
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
    if nargin < 8
        nRepeats = 5;
    end
    if nargin < 7 || isnan(noDeltaT)
        noDeltaT = false;
    end
    if nargin < 6 || isnan(jac)
        jac = false;
    end
    if nargin < 5 || isnan(isLog)
        isLog = true;
    end
    if isLog
        lbs = [-3, -2, -1*ones(1,ndeltas)];
        ubs = [3, 10, 6*ones(1,ndeltas)];        
    else
        lbs = [-20, 10e-6, LOWER_BOUND_DELTA_TEMPORAL*ones(1,ndeltas)];
        ubs = [20, 10e6, 1e5*ones(1,ndeltas)];
    end
    if nargin < 4 || any(isnan(theta0))
        theta0 = pickRandomTheta0(lbs, ubs);
    end
    if jac
        jacStr = 'on';
    else
        jacStr = 'off';
    end
    [p, q] = size(X);
    YY = Y'*Y;
    XY = X'*Y;
    XX = X'*X;
    
    if noDeltaT % full temporal smoothing
        dt = 6; theta0(end) = dt; lbs(end) = dt; ubs(end) = dt;
    end

    % minimize objfcn, with bounds lbs, ubs; starts at theta0
    opts = optimset('display', 'off', 'gradobj', jacStr, ...
        'largescale', 'off', 'algorithm', 'interior-point');
%     opts = optimset('display', 'iter', 'gradobj', jacStr, ...
%         'largescale', 'off', 'algorithm', 'Active-Set');
    obj = @(hyper) objfcn(hyper, Ds, X, Y, XX, XY, YY, p, q, isLog);
    [hyper, fval] = fmincon(obj, theta0, ...
        [], [], [], [], lbs, ubs, [], opts);
    for ii = 1:nRepeats
        theta0 = pickRandomTheta0(lbs, ubs);
        [hyper0, fval0] = fmincon(obj, theta0, ...
            [], [], [], [], lbs, ubs, [], opts);
        if fval0 < fval
            hyper = hyper0;
        end
    end
    if isLog
        hyper = exp(hyper);
    end
end

function [nlogevi, nderlogevi] = objfcn(hyper, Ds, X, Y, XX, XY, YY, p, q, isLog)
    if isLog
        old_hyper = hyper;
        hyper = exp(hyper);
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
        sse =  tools.sse(Y, X, mu);
        Sigma = sigmaInv \ eye(q);
        [der_ro, der_ssq, der_deltas] = asd.gauss.logEvidenceGradient(...
            hyper, p, q, Ds, mu, Sigma, Reg, sse);
        nderlogevi = -[der_ro, der_ssq, der_deltas];
    end
end

function theta0 = pickRandomTheta0(lbs, ubs)
    theta0 = nan(numel(lbs),1);
    for ii = 1:numel(lbs)
        theta0(ii) = lbs(ii) + (ubs(ii)-lbs(ii))*rand;
    end
end

