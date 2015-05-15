function obj = cvFitAndEvaluateHyperparam(obj, trials, fitFcn, scoreFcn)
    
    beDirty = true;
    
    [w, b, hyper] = reg.fitHypersAndWeights(trials.x_train, ...
        trials.y_train, fitFcn(obj.hyper));
    obj.mu = [w; b];
    obj.hyper = hyper;
    if ~isempty(trials.x_test)
        obj.score = scoreFcn(trials, obj.mu, obj.hyper);
    elseif beDirty
        trials.x_test = trials.x_train;
        trials.y_test = trials.y_train;
        obj.score = scoreFcn(trials, obj.mu, obj.hyper);
    else
        obj.score = mean(obj.scores);
    end
end
