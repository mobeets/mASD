function M = logisticASDStruct(D, fitstr)
    if nargin < 2
        fitstr = '';
    end
    
    M.llFcn = @(X_test, R_test, w, hyper) -tools.neglogli_bernoulliGLM(w(1:end-1), X_test, R_test);    
    M.rsqFcn = @(X_test, R_test, w, hyper) tools.rsq(tools.logistic(X_test*w(1:end-1) + w(end)), R_test);

    M.mapFcn = @(hyper0, D) asd.bern.fitopts(hyper0, D, fitstr);
    M.mapFcnOpts = {D};

end
