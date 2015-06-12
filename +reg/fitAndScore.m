function obj = fitAndScore(X, Y, obj, scoreObj)
% 
% obj
%   .llstr - likelihood string; either 'gauss', 'bern', or 'poiss'
%   .isLinReg [bool] - is linear regression (not logistic)
%   .foldinds
%   .fitFcn() = @(X, Y, obj) ...;
%   .hyperObj
%     .fitFcn() = @(X, Y, D, obj.hyperObj.fitFcnArgs{:}) ...;
%     .fitFcnArgs = {...};
% scoreObj
%     .name
%     .scoreFcn() = @(X, Y, w, obj.scoreObj.scoreFcnArgs{:})
%     .scoreFcnArgs = {...};
% 
% Example (ASD linear regression):
%     scoreObj = reg.getScoreObj(true, 'rsq');
%     obj = reg.getObj_ASD(X, Y, D);
%     obj = reg.fitAndScore(X, Y, obj, scoreObj);
% 
% Example (ASD logistic regression):
%     scoreObj = reg.getScoreObj(false, 'pctCorrect');
%     obj = reg.getObj_ASD(X, Y, D, scoreObj);
%     obj = reg.fitAndScore(X, Y, obj, scoreObj);
% 

    % remove empty trials
    ix = ~isnan(Y);
    X = X(ix,:,:);
    Y = Y(ix,:);
    obj.foldinds = obj.foldinds(ix);

    % fit hyperparameters
    if isfield(obj, 'hyperObj')
        obj.hyper = obj.hyperObj.fitFcn(X, Y, obj.hyperObj.fitFcnArgs{:});
    end

    % fit weights
    [obj.w, obj.b] = reg.fitWeights(X, Y, obj);
    obj.mu = [obj.w; obj.b];

    % score
    [scores, mus, scoreDev] = reg.cvFitScores(X, Y, obj, scoreObj);
    obj.mu_cv = mus;
    obj.scores = scores';
    obj.score_dev = scoreDev;
    obj.score_cvMean = mean(obj.scores);
    obj.score_cvStd = std(obj.scores);
    obj.score = obj.score_cvMean;

end

