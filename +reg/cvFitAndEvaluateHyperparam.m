function obj = cvFitAndEvaluateHyperparam(obj, trials, fitFcn, scoreFcn)
    
    [w, b, hyper] = reg.fitHypersAndWeights(trials.x_train, ...
        trials.y_train, fitFcn(obj.hyper));
    obj.mu = [w; b];
    obj.hyper = hyper;
    obj.score = scoreFcn(trials, obj.mu, obj.hyper);
end
