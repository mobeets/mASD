function M = logisticASDStruct(D)
    M.mapFcn = @asd.bern.fitMAP;
    M.llFcn = @(X_test, R_test, w, hyper) -tools.neglogli_bernoulliGLM(w(1:end-1), X_test, R_test);    
    M.rsqFcn = @(X_test, R_test, w, hyper) reg.rsq(tools.logistic(X_test*w(1:end-1) + w(end)), R_test);
    M.mlFcn = @ml.fitBernML;
    M.mapFcnOpts = {D};
end
