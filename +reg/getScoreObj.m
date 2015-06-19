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
    rsqFcn = @(X, Y, w,~) tools.rsq(predictionFcn(X, w), Y);

    correctFcn = @(X, Y, w,~) round(predictionFcn(X, w)) == Y;
    pctCorrectFcn = @(X, Y, w,~) sum(correctFcn(X, Y, w)) / numel(Y);
    pctIncorrectFcn = @(X, Y, w,~) 1-pctCorrectFcn(X, Y, w);
    
    constPrediction = @(Y0, Y) Y0*ones(size(Y,1),1);
    if isLinReg % 'rss' using mean of training set
        tssFcn = @(X, Y, w, ts) tools.rss(constPrediction(mean(ts.y_train),Y), Y);
    else % 'pctIncorrect' using mean of training set
        tssFcn = @(X, Y, w, ts) 1-sum(round(constPrediction(mean(ts.y_train),Y))==Y)/numel(Y);
    end

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
