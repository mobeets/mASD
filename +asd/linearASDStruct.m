function M = linearASDStruct(D, llstr)
    if nargin < 2
        llstr = 'gauss';
    end
    if strcmp(llstr, 'poiss')
        M.llFcn = @(X_test, R_test, w, hyper) -tools.neglogli_poissGLM(w(1:end-1), X_test, R_test, @tools.expfun);
    else
        M.llFcn = @(X_test, Y_test, w, hyper) asd.gauss.logLikelihood(Y_test, X_test, w, hyper(2));
    end
    
%     M.mapFcn = @asd.gauss.fitMAP;
%     M.mapFcn = @(X, Y, hyper0, D) reg.fitHypersAndWeights(X, Y, asd.gauss.fitMAP(hyper0, D));
    M.mapFcn = @(hyper0, D) asd.gauss.fitMAP(hyper0, D);
    M.mapFcnOpts = {D};
    
%     M.minFcn = @(X, Y, hyper0, D) reg.fitHypersAndWeights(X, Y, asd.gauss.fitMinNegLogEvi(hyper0, D));
    M.minFcn = @(hyper0, D) asd.gauss.fitMinNegLogEvi(hyper0, D);
    M.minFcnOpts = {D};
    
    M.rsqFcn = @(X_test, Y_test, w, hyper) tools.rsq(X_test*w(1:end-1) + w(end), Y_test);
    
%     M.mlFcn = @(X, Y, ~) reg.fitHypersAndWeights(X, Y, ml.fitGaussML());
    M.mlFcn = @(~) ml.fitGaussML();
    M.mlFcnOpts = {};
    
end
