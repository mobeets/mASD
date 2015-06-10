function [mxHyper, mxScore, scores] = cvBestHyperGridScore(X, Y, ...
    foldinds, hypergrid, obj, scoreObj)

    trials = tools.trainAndTestKFolds(X, Y, nan, foldinds);
    nfolds = numel(trials);    
    nhypers = size(hypergrid, 1);
    scores = nan(nhypers, nfolds);
    ws = cell(nhypers, nfolds);

    for ii = 1:nfolds
        ctrials = trials(ii);
        for jj = 1:nhypers
            obj.hyper = hypergrid(jj,:);
            [mu, b] = reg.fitWeights(ctrials.x_train, ctrials.y_train, ...
                obj);
            ws{jj,ii} = [mu; b];
            scores(jj,ii) = scoreObj.scoreFcn(ctrials.x_test, ...
                ctrials.y_test, ws{jj,ii}, ctrials, ...
                scoreObj.scoreFcnArgs{:});
        end
    end

    meanScores = mean(scores, 2);
    [~, idx] = max(meanScores);
    mxHyper = hypergrid(idx,:);
    mxScore = scores(idx,:);

end
