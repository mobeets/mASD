function M = linearASDStruct(D, llstr)
    if nargin < 2
        llstr = 'gauss';
    end
    if strcmp(llstr, 'poiss')
        M.llFcn = @(X_test, R_test, w, hyper) -tools.neglogli_poissGLM(w(1:end-1), X_test, R_test, @tools.expfun);
    else
        M.llFcn = @(X_test, Y_test, w, hyper) asd.gauss.logLikelihood(Y_test, X_test, w, hyper(2));
    end
    M.mapFcn = @asd.gauss.fitMAP;
    M.minFcn = @asd.gauss.fitMinNegLogEvi;
    M.rsqFcn = @(X_test, Y_test, w, hyper) reg.rsq(X_test*w(1:end-1) + w(end), Y_test);
    M.mlFcn = @ml.fitGaussML;
    M.mapFcnOpts = {D};
end
