function wMAP = calcMAP(X, Y, hyper, D)

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
    w0 = (XB'*XB)\(XB'*Y); % stupid starting point
    wMAP = fminunc(nlogpost, w0, objopts);
    wMAP = B*wMAP;
    
end
