function M = logisticASDStruct(D)

%     M.mapFcn = @(X, Y, hyper0, D) reg.fitHypersAndWeights(X, Y, asd.bern.fitMAP(hyper0, D));
    M.mapFcn = @(hyper0, D) asd.bern.fitMAP(hyper0, D);
    M.mapFcnOpts = {D};
    
    M.llFcn = @(X_test, R_test, w, hyper) -tools.neglogli_bernoulliGLM(w(1:end-1), X_test, R_test);    
    M.rsqFcn = @(X_test, R_test, w, hyper) tools.rsq(tools.logistic(X_test*w(1:end-1) + w(end)), R_test);

%     M.mlFcn = @(X, Y, ~) reg.fitHypersAndWeights(X, Y, ml.fitBernML());
    M.mlFcn = @(~) ml.fitBernML();
    M.mlFcnOpts = {};
    
end
