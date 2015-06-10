function [mxHyper, mxScore, scores] = cvBestHyperGridScore(X, Y, ...
    foldinds, hypergrid, obj, scoreObj)

    trials = tools.trainAndTestKFolds(X, Y, nan, foldinds);
    nfolds = numel(trials);    
    nhypers = size(hypergrid, 1);
    scores = nan(nfolds, nhypers);
    ws = cell(nfolds, nhypers);

    for ii = 1:nfolds
        ctrials = trials(ii);
        for jj = 1:nhypers
            obj.hyper = hypergrid(jj,:);
            [mu, b] = reg.fitWeights(ctrials.x_train, ctrials.y_train, ...
                obj);
            ws{ii,jj} = [mu; b];
            scores(ii,jj) = scoreObj.scoreFcn(ctrials.x_test, ...
                ctrials.y_test, ws{ii,jj}, ctrials, ...
                scoreObj.scoreFcnArgs{:});
        end
    end

    meanScores = mean(scores, 2);
    [~, idx] = max(meanScores);
    mxHyper = hypergrid(idx,:);
    mxScore = scores(idx,:);

end
