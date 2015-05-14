function obj = cvFitAndEvaluateHyperparam(obj, trials, fitFcn, scoreFcn)
    
    [w, b, hyper] = reg.fitHypersAndWeights(trials.x_train, ...
        trials.y_train, fitFcn(obj.hyper));
    obj.mu = [w; b];
    obj.hyper = hyper;
    if ~isempty(trials.x_test)
        obj.score = scoreFcn(trials, obj.mu, obj.hyper);
    else
        obj.score = mean(obj.scores);
    end
end
