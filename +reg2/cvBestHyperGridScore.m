function [mxHyper, mxScore, scores] = cvBestHyperGridScore(X, Y, ...
    foldinds, hypergrid, obj, scoreObj)

    trials = reg.trainAndTestKFolds(X, Y, nan, foldinds);
    nfolds = numel(trials);    
    nhypers = size(hypergrid, 1);
    scores = nan(nfolds, nhypers);
    ws = cell(nfolds, nhypers);

    for ii = 1:nfolds
        ctrials = trials(ii);
        for jj = 1:nhypers
            obj.hyper = hypergrid(jj,:);
            [mu, b] = reg2.fitWeights(ctrials.x_train, ctrials.y_train, ...
                obj);
            w = [mu; b];
            ws{ii,jj} = w;
            scores(ii,jj) = scoreObj.scoreFcn(ctrials.x_test, ...
                ctrials.y_test, w, ctrials, scoreObj.scoreFcnArgs{:});
        end
    end

    meanScores = mean(scores, 2);
    [~, idx] = max(meanScores);
    mxHyper = hypergrid(idx,:);
    mxScore = scores(idx,:);

end
