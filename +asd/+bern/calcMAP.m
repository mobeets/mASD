function wMAP = calcMAP(X, Y, hyper, D, lbs)
% wMAP = calcMAP(X, Y, hyper, D, lbs, ubs)
% 
% fits the MAP estimate for w s.t. Y ~ logistic(X*w) with an ASD prior on w
%   X [nt x nw] - stimulus
%   Y [nt x 1] - response (binary, 0/1)
%   hyper - ASD hyperparameter describing the shrinkage, and smoothness
%   D - distance matrix, for ASD%
% optional:
%   lbs [nw x 1] - lower bounds on w
% 
    if nargin < 5
        lbs = [];
    end

    [ro, ~, deltas] = asd.unpackHyper(hyper, false);
    Reg = asd.prior(ro, D, deltas);
    [RegInv, B] = asd.invPrior(Reg);
    XB = X*B;

    mstruct.neglogli = @tools.neglogli_bernoulliGLM;
    mstruct.logprior = @(w, ~, RegInv) tools.gaussLogPrior(w, 0, RegInv, true);
    mstruct.liargs = {XB, Y};
    mstruct.priargs = {RegInv};
    nlogpost = @(w) tools.neglogpost_GLM(w, hyper, mstruct);

    objopts = optimset('display', 'off', 'gradobj', 'on', ...
            'largescale', 'off', 'algorithm', 'Active-Set');
    w0 = zeros(size(B,2),1); % always seems better!
    
    if ~isempty(lbs)
        wMAP = fmincon(nlogpost, w0, -B, -lbs,[],[],[],[],[], objopts);
    else
        wMAP = fminunc(nlogpost, w0, objopts);
    end
    wMAP = B*wMAP;
    
end
