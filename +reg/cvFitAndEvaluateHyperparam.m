function obj = cvFitAndEvaluateHyperparam(obj, trials, fitFcn, ...
    fitFcnOpts, scoreFcn, scFcnOpts)
    
    [w, b, hyper] = reg.fitHypersAndWeights(trials.x_train, ...
        trials.y_train, fitFcn(obj.hyper, fitFcnOpts{:}));
    obj.mu = [w; b];
    obj.hyper = hyper;
    obj.score = scoreFcn(trials, obj.mu, obj.hyper, scFcnOpts{:});
end
