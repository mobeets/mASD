function hyper = optMinNegLogEvi_ARD(X, Y, maxiters, thresh, wML, pRdg)
% wML - ML solution, for initializing

n = size(X,1);
d = size(X,2);

if nargin < 6 || all(isnan(pRdg))
    useRdg = false;
else
    if numel(pRdg) ~= 2
        warning('Ridge solution not the right length. Ignoring.');
        useRdg = false;
    else
        useRdg = true;
    end
end
if nargin < 5 || any(isnan(wML)) || useRdg
    useML = false;
else
    if d ~= numel(wML)
        warning('ML solution not the right length. Ignoring.');
        useML = false;
    else
        useML = true;
    end
end

rhos = nan(maxiters,d);
ssqs = nan(maxiters,1);

% initialize
if useRdg
    rhos(1,:) = pRdg(1)*ones(d,1);
    ssqs(1) = pRdg(2);
else
    rhos(1,:) = 10e-6; % from Park & Pillow
    if useML
        ssqs(1) = tools.sse(Y, X, wML)/n;
    else
        ssqs(1) = Y'*Y/n; % assumes weights are 0, Y zero mean
    end
end

XY = X'*Y;
XX = X'*X;

for ii = 2:maxiters
    
    RegInv = ml.ridgeInvPrior(diag(rhos(ii-1,:)), d);
    SigmaInv = tools.postCovInv(RegInv, XX, ssqs(ii-1));
    mu = tools.postMean(SigmaInv, XY, ssqs(ii-1));

    Sigma = inv(SigmaInv);
    sigmaDiag = diag(Sigma)';
    
    A = 1 - sigmaDiag.*rhos(ii-1,:);
    sse = tools.sse(Y, X, mu);
    
    rho = (mu.^2)'./A;
    ssq = sse/(n - sum(A));
    
%     rho(rho < thresh) = 0;
    
    if any(isinf(rho)) || isinf(ssq)
        error('rho or ssq became infinite.');
    end
    rhos(ii,:) = rho;
    ssqs(ii) = ssq;    
    
    % check for convergence
    if norm([rho ssq] - [rhos(ii-1,:) ssqs(ii-1)]) < thresh
        break;
    end
end
hyper = [rho ssq];

end
