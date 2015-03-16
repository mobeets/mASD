function obj = linearRegressionScoreFcns(llstr)
    addones = @(X) [X ones(size(X,1),1)];
    if strcmp(llstr, 'poiss')
        obj.llFcn = @(trials, w, hyper) -tools.neglogli_poissGLM(...
            w, addones(trials.x_test), trials.y_test, @tools.expfun);
    elseif strcmp(llstr, 'gauss')
        obj.llFcn = @(trials, w, hyper) asd.gauss.logLikelihood(...
            trials.y_test, addones(trials.x_test), w, hyper(2));
    end
    obj.rsqFcn = @(trials, w, hyper) ...
        tools.rsq(addones(trials.x_test)*w, trials.y_test);
end
