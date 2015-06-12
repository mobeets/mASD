function [scores, mus, scoreDev, mu] = cvFitScores(X, Y, obj, scoreObj)
    trials = tools.trainAndTestKFolds(X, Y, nan, obj.foldinds);
    nfolds = numel(trials);
    mus = cell(nfolds, 1);
    scores = nan(nfolds, 1);
    for ii = 1:nfolds
        ctrials = trials(ii);
        [w, b] = reg.fitWeights(ctrials.x_train, ctrials.y_train, obj);
        mus{ii} = [w; b];
        scores(ii) = scoreObj.scoreFcn(ctrials.x_test, ...
            ctrials.y_test, mus{ii}, ctrials, scoreObj.scoreFcnArgs{:});
    end
    [w, b] = reg.fitWeights(X, Y, obj);
    mu = [w; b];
    scoreDev = scoreObj.scoreFcn(X, Y, mu, ...
        scoreObj.scoreFcnArgs{:});
end
