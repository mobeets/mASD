function M = logisticASDStruct(D, fitstr)
    if nargin < 2
        fitstr = '';
    end
    
    M.llFcn = @(X_test, R_test, w, hyper) -tools.neglogli_bernoulliGLM(w(1:end-1), X_test, R_test);    
    M.rsqFcn = @(X_test, R_test, w, hyper) tools.rsq(tools.logistic(X_test*w(1:end-1) + w(end)), R_test);
    M.mapFcn = @(hyper0) fitopts(hyper0, D, fitstr);

end

function opts = fitopts(hyper0, D, fitstr)
    if nargin < 3
        fitstr = '';
    end
    if strcmpi(fitstr, 'evi')
        opts.hyperFcn = @asd.bern.optMinNegLogEvi;
        opts.hyperFcnArgs = {hyper0, D, true};
    else
        opts.hyperFcn = @(X, Y, hyper) hyper;
        opts.hyperFcnArgs = {hyper0};
    end
    opts.fitIntercept = true;
    opts.centerX = false;
    opts.muFcn = @asd.bern.calcMAP;
    opts.muFcnArgs = {D};
end
