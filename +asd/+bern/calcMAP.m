function wMAP = calcMAP(X, Y, hyper, D)

    [ro, ~, deltas] = asd.unpackHyper(hyper, false);
    Reg = asd.prior(ro, D, deltas);
    [RegInv, B] = asd.invPrior(Reg);
    XB = X*B;
    zer = zeros(size(XB,2),1);

    mstruct.neglogli = @tools.neglogli_bernoulliGLM;
    mstruct.logprior = @getLogPrior;
    mstruct.liargs = {XB, Y};
    mstruct.priargs = {zer, RegInv};
    nlogpost = @(w) tools.neglogpost_GLM(w, hyper, mstruct);

    objopts = optimset('display', 'off', 'gradobj', 'on', ...
            'largescale', 'off', 'algorithm', 'Active-Set');
    w0 = (XB'*XB)\(XB'*Y); % stupid starting point
    wMAP = fminunc(nlogpost, w0, objopts);
    wMAP = B*wMAP;
    
end

function [v, dv, ddv] = getLogPrior(w, ~, zer, RegInv)
    if nargout <= 1
        v = tools.gaussLogPrior(w, zer, RegInv, true);
    elseif nargout == 2
        [v, dv] = tools.gaussLogPrior(w, zer, RegInv, true);
    elseif nargout == 3
        [v, dv, ddv] = tools.gaussLogPrior(w, zer, RegInv, true);
    end
end
