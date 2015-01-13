function [wMAP, b, hyper] = bernASD_MAP(X, Y, hyper, opts)

    [X, Y, X_mean, Y_mean] = reg.centerData(X, Y, opts.fitIntercept);
    [ro, ~, deltas] = asd.unpackHyper(hyper, false);
    Reg = asd.prior(ro, opts.D, deltas);
    [~, isNotPosDef] = chol(Reg);
    if isNotPosDef
        % svd trick
        tol = 1e-8;
        [U, s, ~] = svd(Reg);
        s = diag(s);
        inds = s/s(1) > tol;
%         disp(['SVD removed ' num2str(sum(inds)) ' of ' num2str(numel(inds))]);
        RegInv = diag(1/s(inds));
        B = U(:,inds);
        XB = X*B;
    else
        % no trick
        q = eye(size(Reg,1));
        RegInv = Reg\q;
        B = q;
        XB = X*B;
    end

    zer = zeros(size(XB,2),1);

    mstruct.neglogli = @regtools.neglogli_bernoulliGLM;
    % mstruct.logprior = @tools.gaussLogPrior;
    mstruct.logprior = @getLogPrior;
    mstruct.liargs = {XB, Y};
    mstruct.priargs = {zer, RegInv};
    nlogpost = @(w) regtools.neglogpost_GLM(w, hyper, mstruct);

    % nlogprior = @(w) -tools.gaussLogPrior(w, zer, asd.prior(ro, opts.D, deltas), false);
    % nloglike = @(w) regtools.neglogli_bernoulliGLM(w, X, Y);
    % nlogpost = @(w) nlogprior(w) + nloglike(w);

    w0 = (XB'*XB)\(XB'*Y); % stupid starting point
    objopts = optimset('display', 'off', 'gradobj', 'on', ...
            'largescale', 'off', 'algorithm', 'Active-Set');
    % wMAP = fmincon(obj, w0, [], [], [], [], lbs, ubs, [], opts);
    wMAP = fminunc(nlogpost, w0, objopts);
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
