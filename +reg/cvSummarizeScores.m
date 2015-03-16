function obj = cvSummarizeScores(scores, hypergrid, mus)
    nfolds = size(scores, 2); % average across folds
    mean_scores = mean(scores, 2);
    [~, idx] = max(mean_scores); % choose hyper with highest mean score
    hyper = hypergrid(idx,:);
    scs = scores(idx,:);
    if ~isempty(mus)
        mu = cell(nfolds,1);
        [mu{:}] = mus{idx,:};
        obj.mus = mu;
        obj.muCorrFolds = corrcoef([obj.mus{:}]); % across folds
    else
        obj.mus = nan;
        obj.muCorrFolds = nan;
    end
    obj.hyper = hyper;
    obj.scores = scs;
    obj.scoreVarFolds = std(obj.scores); % std dev of scores across folds
end
