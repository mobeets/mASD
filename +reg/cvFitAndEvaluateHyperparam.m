function obj = cvFitAndEvaluateHyperparam(obj, trials, fitFcn, scoreFcn)
    
    [w, b, hyper] = reg.fitHypersAndWeights(trials.x_train, ...
        trials.y_train, fitFcn(obj.hyper));
    obj.mu = [w; b];
    obj.hyper = hyper;

    ts.x_test = trials.x_train; ts.y_test = trials.y_train;
    obj.score_dev = scoreFcn(ts, obj.mu, obj.hyper);
    obj.score_eval = scoreFcn(trials, obj.mu, obj.hyper);
    obj.score_cvMean = mean(obj.scores);
    obj.score_cvStd = std(obj.scores);
    
    if ~isnan(obj.score_eval)
        obj.score = obj.score_eval;
    elseif ~isnan(obj.score_cvMean)
        obj.score = obj.score_cvMean;
    else
        obj.score = obj.score_dev;
    end
end
