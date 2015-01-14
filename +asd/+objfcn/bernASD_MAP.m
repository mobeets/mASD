function [wMAP, b, hyper, negLogPostVal] = bernASD_MAP(X, Y, hyper, opts)

    [X, Y, X_mean, Y_mean] = reg.centerData(X, Y, opts.fitIntercept);
    [ro, ~, deltas] = asd.unpackHyper(hyper, false);
    Reg = asd.prior(ro, opts.D, deltas);
    [RegInv, B] = asd.invPrior(Reg);
    XB = X*B;
    zer = zeros(size(XB,2),1);

    mstruct.neglogli = @tools.neglogli_bernoulliGLM;
    % mstruct.logprior = @tools.gaussLogPrior;
    mstruct.logprior = @getLogPrior;
    mstruct.liargs = {XB, Y};
    mstruct.priargs = {zer, RegInv};
    nlogpost = @(w) tools.neglogpost_GLM(w, hyper, mstruct);

    % nlogprior = @(w) -tools.gaussLogPrior(w, zer, asd.prior(ro, opts.D, deltas), false);
    % nloglike = @(w) tools.neglogli_bernoulliGLM(w, X, Y);
    % nlogpost = @(w) nlogprior(w) + nloglike(w);

    w0 = (XB'*XB)\(XB'*Y); % stupid starting point
    objopts = optimset('display', 'off', 'gradobj', 'on', ...
            'largescale', 'off', 'algorithm', 'Active-Set');
    % wMAP = fmincon(obj, w0, [], [], [], [], lbs, ubs, [], opts);
    wMAP = fminunc(nlogpost, w0, objopts);
    negLogPostVal = tools.neglogpost_GLM(wMAP, hyper, mstruct);
    wMAP = B*wMAP;
    b = reg.setIntercept(X_mean, Y_mean, wMAP, opts.fitIntercept);
    
end

function [v, dv, ddv] = getLogPrior(w, hyper, zer, RegInv)
    if nargout <= 1
        v = tools.gaussLogPrior(w, zer, RegInv, true);
    elseif nargout == 2
        [v, dv] = tools.gaussLogPrior(w, zer, RegInv, true);
    elseif nargout == 3
        [v, dv, ddv] = tools.gaussLogPrior(w, zer, RegInv, true);
    end
end
