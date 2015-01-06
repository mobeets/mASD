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
    if nargin < 6 or isnan(jac)
        jac = false;
    end
    if nargin < 5 or isnan(isLog)
        isLog = true;
    end
    if nargin < 4 or isnan(theta0)
        theta0 = [1.0, 0.1, + 2.0*ones(1,ndeltas)];
    end
    
    if isLog
        theta0 = log(theta0);
        lbs = [-3, -2, -5*ones(1,ndeltas)];
        ubs = [3, 2, 10*ones(1,ndeltas)];
    else
        lbs = [-20, 10e-6, LOWER_BOUND_DELTA_TEMPORAL*ones(1,ndeltas)];
        ubs = [20, 10e6, 1e5*ones(1,ndeltas)];
    end
    [p, q] = size(X);
    YY = Y'*Y';
    XY = X'*Y;
    XX = X'*X;

    function [nlogevi, nderlogevi] = objfcn(hyper)
        if isLog
            hyper = exp(hyper);
        end
        [ro, ssq, deltas] = unpackHyper(hyper);
        Reg = ASDReg(ro, Ds, deltas);
        try
            chol(Reg); % raises exception if not positive definite
            SigmaInv = PostCovInv(inv(Reg), XX, ssq);
            logevi = ASDLogEvi(XX, YY, XY, Reg, SigmaInv, ssq, p, q);
        catch
            logevi = ASDLogEviSVD(X, Y, YY, Reg, ssq); % svd trick
        end
        nlogevi = -logevi;
        if nargout > 1
            mu = PostMean(SigmaInv, XY, ssq);
            sse =  SSE(Y, X, mu);
            nderlogevi = -ASDEviGradient(hyper, p, q, Ds, mu, inv(SigmaInv), Reg, sse);
        end
    end

    % minimize objfcn, with bounds lbs, ubs; starts at theta0
    opts = optimset('display', 'iter', 'gradobj', 'off', 'largescale', 'off', ...
        'algorithm', 'Active-Set');
    hyper = fmincon(objfcn, theta0, [], [], [], [], lbs, ubs, [], opts);
    if isLog
        hyper = exp(hyper);
    end
    disp(hyper);
    [ro, ssq, deltas] = unpackHyper(hyper);

    Reg = ASDReg(ro, Ds, deltas);
    [mu, ~] = MeanInvCov(XX, XY, Reg, ssq);
end
%%
function [ro, ssq, deltas] = unpackHyper(hyper)
    ro = hyper(1);
    ssq = hyper(2);
    deltas = hyper(3:end);
end

function v = SSE(Y, X, mu)
    t = Y - X*mu;
    v = t'*t;
end

function v = PostCovInv(RegInv, XX, ssq)
    v = XX/ssq + RegInv;
end

function v = PostMean(SigmaInv, XY, ssq)
    v = (SigmaInv \ XY)/ssq;
end

function [Mu, SigmaInv] = MeanInvCov(XX, XY, Reg, ssq)
    SigmaInv = PostCovInv(inv(Reg), XX, ssq);
    Mu = PostMean(SigmaInv, XY, ssq);
end

function v = RidgeReg(ro, q)
    v = exp(-ro)*eye(q);
end

function v = ASDReg(ro, Ds, deltas)
% 
% ro - float
% Ds, deltas - vectors of:
%     D - (q x q) squared distance matrix in some stimulus dimension
%     delta - float, the weighting of D
% 
    vs = 0.0;
    for ii = 1:numel(deltas)
        vs = vs + Ds(:,:,ii)/(deltas(ii)^2);
    end
    v = np.exp(-ro-0.5*vs);
end
%%
function v = ASDLogEviSVD(X, Y, YY, Reg, ssq, tol)
%
% calculate log-evidence in basis defined by eigenvalues of Reg > tol*S[0]
%     where S[0] is largest eigenvalue
% i.e., if Reg is m x m and only k of Reg's eigenvalues meet this criteria,
%     this function uses the rank-k approximation of Reg
%
    if nargin < 6
        tol = 1e-8;
    end
    [U, s, ~] = svd(Reg);
    s = diag(s);
    inds = s/s(1) > tol;
    disp(['SVD removed ' num2str(sum(inds)) ' of ' num2str(len(inds))]);
    RegInv = diag(1/s(inds));
    B = U(:,inds);
    XB = X*B;
    [p2, q2] = size(XB);
    XBXB = XB'*XB;
    XBY = XB'*Y;
    SigmaInv = PostCovInv(RegInv, XBXB, ssq);
    v = ASDLogEvi(XBXB, YY, XBY, np.diag(s(inds)), SigmaInv, ssq, p2, q2);
end
    
function v = ASDLogEvi(XX, YY, XY, Reg, SigmaInv, ssq, p, q)
% 
% XX is X.T.dot(X) - m x m
% YY is Y.T.dot(Y) - 1 x 1
% XY is X.T.dot(Y) - m x 1
% 
    A = -logdet((Reg*XX)/ssq + eye(q)) - p*log(2*pi*ssq);
    B = YY/ssq - (XY' * SigmaInv \ XY)/(ssq^2); % linv
    v = (A - B)/2.0;
end

function [der_ro, der_ssq, der_deltas] = ASDEviGradient(hyper, p, q, Ds, mu, Sigma, Reg, sse)
% 
% gradient of log evidence w.r.t. hyperparameters
% 
    [ro, ssq, deltas] = unpackHyper(hyper);
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
%%
function v = ASDLogLikelihood(Y, X, mu, ssq)
    sse = SSE(Y, X, mu);
    v = -sse/(2.0*ssq) - log(2*pi*ssq)/2.0;
end

function [XX, XY, YY, p, q, Reg] = ASDInit(X, Y, D, hyper)
    [ro, ssq, deltas] = unpackHyper(hyper);
    XX = X.T.dot(X);
    XY = X.T.dot(Y);
    YY = Y.T.dot(Y);
    [p, q] = X.shape;
    Reg = ASDReg(ro, D, deltas);
end

function v = evidence(X, Y, D, hyper)
    [ro, ssq, deltas] = unpackHyper(hyper);
    [XX, XY, YY, p, q, Reg] = ASDInit(X, Y, D, hyper);
    SigmaInv = PostCovInv(inv(Reg), XX, ssq);
    v = ASDLogEvi(XX, YY, XY, Reg, SigmaInv, ssq, p, q);
end

function v = loglikelihood(X, Y, D, hyper)
    [ro, ssq, deltas] = unpackHyper(hyper);
    [XX, XY, YY, p, q, Reg] = ASDInit(X, Y, D, hyper);
    [mu, ~] = MeanInvCov(XX, XY, Reg, ssq);
    v = ASDLogLikelihood(Y, X, mu, ssq);
end

function [evi, nll] = scores(X0, Y0, X1, Y1, D, hyper)
    evi = evidence(X0, Y0, D, hyper);
    nll = -loglikelihood(X1, Y1, D, hyper);
end
