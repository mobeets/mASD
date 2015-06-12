function scoreObj = getScoreObj(isLinReg, scoreType)
    if nargin < 2
        if isLinReg
            scoreType = 'rsq';
        else
            scoreType = 'pctCorrect';
        end
    end
    predictionFcn = reg.getPredictionFcn(isLinReg);
    rssFcn = @(X, Y, w,~) tools.rss(predictionFcn(X, w), Y);
    tssFcn = @(X, Y, w, ts) tools.rss(mean(ts.y_train)*ones(size(Y,1),1), Y);
    rsqFcn = @(X, Y, w,~) tools.rsq(predictionFcn(X, w), Y);

    correctFcn = @(X, Y, w,~) round(predictionFcn(X, w)) == Y;
    pctCorrectFcn = @(X, Y, w,~) sum(correctFcn(X, Y, w)) / numel(Y);
    pctIncorrectFcn = @(X, Y, w,~) 1-pctCorrectFcn(X, Y, w);

    scoreObj.scoreType = scoreType;
    scoreObj.scoreFcnArgs = {}; % trials are passed, then these args
    switch scoreType
        case 'rsq'
            scoreObj.scoreFcn = rsqFcn;
        case 'rss'
            scoreObj.scoreFcn = rssFcn;
        case 'tss'
            scoreObj.scoreFcn = tssFcn;
        case 'pctCorrect'
            scoreObj.scoreFcn = pctCorrectFcn;
        case 'pctIncorrect'
            scoreObj.scoreFcn = pctIncorrectFcn;
    end    
end
