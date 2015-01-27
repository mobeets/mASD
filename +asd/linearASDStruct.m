function M = linearASDStruct(D, llstr, fitstr)
    if nargin < 2
        llstr = 'gauss';
    end
    if nargin < 3
        fitstr = '';
    end
    
    if strcmp(llstr, 'poiss')
        M.llFcn = @(X_test, R_test, w, hyper) -tools.neglogli_poissGLM(w(1:end-1), X_test, R_test, @tools.expfun);
    elseif strcmp(llstr, 'gauss')
        M.llFcn = @(X_test, Y_test, w, hyper) asd.gauss.logLikelihood(Y_test, X_test, w, hyper(2));
    end
    M.rsqFcn = @(X_test, Y_test, w, hyper) tools.rsq(X_test*w(1:end-1) + w(end), Y_test);
    
    M.mapFcn = @(hyper0, D) asd.gauss.fitopts(hyper0, D, fitstr);
    M.mapFcnOpts = {D};

end
