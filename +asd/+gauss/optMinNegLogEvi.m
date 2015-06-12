function hyper = optMinNegLogEvi(X, Y, Ds, theta0, gradObj, ...
    noDeltaT, nRepeats, willFitIntercept)
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
    isLog = true;
    ndeltas = size(Ds, 3);
    lbs = [-20, -10, -1*ones(1,ndeltas)];
    ubs = [20, 6, 6*ones(1,ndeltas)];
    if ~isLog
        lbs(2:end) = exp(lbs(2:end)); ubs(2:end) = exp(ubs(2:end));
    end
    
    if nargin < 8
        willFitIntercept = true;
    end
    if nargin < 7
        nRepeats = 5;
    end
    if nargin < 6 || isnan(noDeltaT)
        noDeltaT = false;
    end
    if nargin < 5 || isnan(gradObj)
        gradObj = false;
    end
    if nargin < 4 || any(isnan(theta0))
        theta0 = pickRandomTheta0(lbs, ubs, isLog);
%         theta0 = [1.1529  160.2757    1.0093    1.0048];
%         theta0(2:end) = log(theta0(2:end))
    end
    if gradObj
        gradStr = 'on';
    else
        gradStr = 'off';
    end
    [p, q] = size(X);
    
    if willFitIntercept
        Y = Y - mean(Y);
    end
    YY = Y'*Y;
    XY = X'*Y;
    XX = X'*X;    
    
    if noDeltaT % full temporal smoothing
        dt = 6; theta0(end) = dt; lbs(end) = dt; ubs(end) = dt;
    end

    % minimize objfcn, with bounds lbs, ubs; starts at theta0
    opts = optimset('display', 'off', 'gradobj', gradStr, ...
        'largescale', 'off', 'algorithm', 'sqp', 'MaxFunEvals', 1e3, ...        
        'AlwaysHonorConstraints', 'none'); % interior-point, 'Active-Set'
%     'DerivativeCheck', 'on', ...

    obj = @(hyper) objfcn(hyper, Ds, X, Y, XX, XY, YY, p, q, isLog);
    [hyper, fval] = fmincon(obj, theta0, ...
        [], [], [], [], lbs, ubs, [], opts);
    
    hyper0s = nan(nRepeats+1,2+ndeltas);
    theta0s = nan(nRepeats+1,2+ndeltas);
    fvals = nan(nRepeats+1,1);
    hyper0s(1,:) = hyper;
    theta0s(1,:) = theta0;
    fvals(1) = fval;
    for ii = 1:nRepeats
        theta0 = pickRandomTheta0(lbs, ubs, isLog);        
        [hyper0, fval0] = fmincon(obj, theta0, ...
            [], [], [], [], lbs, ubs, [], opts);        
        theta0s(ii+1,:) = theta0;
        fvals(ii+1) = fval0;
        hyper0s(ii+1,:) = hyper0;
        if fval0 < fval
            hyper = hyper0;
            fval = fval0;
        end
    end
    if isLog
        hyper(2:end) = exp(hyper(2:end));
    end
    hyper = hyper';
end

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
        Sigma = sigmaInv \ eye(q);
        [der_ro, der_ssq, der_deltas] = asd.gauss.logEvidenceGradient(...
            hyper, p, q, Ds, mu, Sigma, Reg, sse);
        derlogevi = [der_ro, der_ssq, der_deltas];
        nderlogevi = -derlogevi;
        if isLog
            nderlogevi(2:end) = -log(derlogevi(2:end));
        end
    end
end

function theta0 = pickRandomTheta0(lbs, ubs, isLog)
    if ~isLog
        lbs(2:end) = log(lbs(2:end)); ubs(2:end) = log(ubs(2:end));
    end
    theta0 = nan(numel(lbs),1);
    for ii = 1:numel(lbs)
        theta0(ii) = lbs(ii) + (ubs(ii)-lbs(ii))*rand;
    end
    if ~isLog
        theta0(2:end) = exp(theta0(2:end));
    end
end
