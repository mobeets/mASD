function [mxHyper, mxScore, scores] = cvHyperFitScores(X, Y, obj, scoreObj)

    hypergrid = obj.hyperObj.hypergrid;
    trials = tools.trainAndTestKFolds(X, Y, nan, obj.hyperObj.foldinds);
    nfolds = numel(trials);    
    nhypers = size(hypergrid, 1);
    scores = nan(nhypers, nfolds);
    mus = cell(nhypers, nfolds);

    for ii = 1:nfolds
        ctrials = trials(ii);
        for jj = 1:nhypers
            obj.hyper = hypergrid(jj,:);
            [w, b] = reg.fitWeights(ctrials.x_train, ctrials.y_train, ...
                obj);
            mus{jj,ii} = [w; b];
            scores(jj,ii) = scoreObj.scoreFcn(ctrials.x_test, ...
                ctrials.y_test, mus{jj,ii}, ctrials, ...
                scoreObj.scoreFcnArgs{:});
        end
    end

    meanScores = mean(scores, 2);
    [~, idx] = max(meanScores);
    mxHyper = hypergrid(idx,:);
    mxScore = scores(idx,:);

end
