function obj = cvFitAndEvaluateHyperparam(obj, trials, fcns)
    
    [w, b, hyper] = reg.fitHypersAndWeights(trials.x_train, ...
        trials.y_train, fcns.fitFcn(obj.hyper, fcns.fitFcnOpts{:}));
    obj.mu = [w; b];
    obj.hyper = hyper;
    obj.score = fcns.scoreFcn(trials, obj.mu, obj.hyper, ...
        fcns.scoreFcnOpts{:});
end
