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
%     scoreObj = reg.getScoreObj('rsq', true);
%     obj = reg.getObj_ASD(X, Y, D);
%     obj = reg.fitAndScore(X, Y, obj, scoreObj);
% 
% Example (ASD logistic regression):
%     scoreObj = reg.getScoreObj('pctCorrect', false);
%     obj = reg.getObj_ASD(X, Y, D, scoreObj);
%     obj = reg.fitAndScore(X, Y, obj, scoreObj);
% 

    % remove empty trials
    inds = isnan(Y);
    X = X(~inds,:,:);
    Y = Y(~inds,:);
    obj.foldinds = obj.foldinds(~inds);

    % fit hyperparameters
    if isfield(obj, 'hyperObj')
        obj.hyper = obj.hyperObj.fitFcn(X, Y, obj, scoreObj);
    end

    % fit weights
    [obj.mu, obj.b] = reg.fitWeights(X, Y, obj);
    obj.w = [obj.mu; obj.b];

    % score
    [scores, ws, scoreDev] = reg.cvFitScores(X, Y, obj, scoreObj);
    obj.w_cv = ws;
    obj.scores = scores';
    obj.score_dev = scoreDev;
    obj.score_cvMean = mean(obj.scores);
    obj.score_cvStd = std(obj.scores);
    obj.score = obj.score_cvMean;

end

