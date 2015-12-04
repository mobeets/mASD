function hyper = optMinNegLogEvi_ridge(X, Y, maxiters, thresh, wML)
% wML - ML solution, for initializing

n = size(X,1);
d = size(X,2);

if nargin < 5 || any(isnan(wML))
    useML = false;
else
    if d ~= numel(wML)
        warning('ML solution not the right length. Ignoring.');
        useML = false;
    else
        useML = true;
    end
end

rhos = nan(maxiters,1);
ssqs = nan(maxiters,1);

% initialize
rhos(1) = 10e-6; % from Park & Pillow
ssqs(1) = Y'*Y/n; % assumes weights are 0, Y zero mean

if useML
    ssqs(1) = tools.sse(Y, X, wML)/n;
else
    warning('Not starting from ML solution.');
end

XY = X'*Y;
XX = X'*X;

for ii = 2:maxiters
    
    RegInv = ml.ridgeInvPrior(rhos(ii-1), d);
    SigmaInv = tools.postCovInv(RegInv, XX, ssqs(ii-1));
    mu = tools.postMean(SigmaInv, XY, ssqs(ii-1));

    Sigma = inv(SigmaInv);
    traceOfSigma = trace(Sigma);
%     D = svd(SigmaInv);
%     traceOfSigma = sum(1./D);
    A = d - rhos(ii-1)*traceOfSigma;
    sse = tools.sse(Y, X, mu);
    
%     rho = A/sum(mu.^2);
    rho = sum(mu.^2)/A;
    ssq = sse/(n - A);
    
    if isinf(rho) || isinf(ssq)
        error('rho or ssq became infinite.');
    end
    rhos(ii) = rho;
    ssqs(ii) = ssq;
    
    % check for convergence
    if norm([rho; ssq] - [rhos(ii-1); ssqs(ii-1)]) < thresh
        break;
    end
end
hyper = [rho ssq];

end
