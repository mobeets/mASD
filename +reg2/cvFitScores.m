function [scores, ws, scoreDev, w] = cvFitScores(X, Y, obj, scoreObj)
    trials = reg.trainAndTestKFolds(X, Y, nan, obj.foldinds);
    nfolds = numel(trials);
    ws = cell(nfolds, 1);
    scores = nan(nfolds, 1);
    for ii = 1:nfolds
        ctrials = trials(ii);
        [mu, b] = reg2.fitWeights(ctrials.x_train, ctrials.y_train, obj);
        ws{ii} = [mu; b];
        scores(ii) = scoreObj.scoreFcn(ctrials.x_test, ...
            ctrials.y_test, ws{ii}, ctrials, scoreObj.scoreFcnArgs{:});
    end
    [mu, b] = reg2.fitWeights(X, Y, obj);
    w = [mu; b];
    scoreDev = scoreObj.scoreFcn(X, Y, w, ...
        scoreObj.scoreFcnArgs{:});
end
