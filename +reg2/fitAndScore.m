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
% Example:
%     obj = reg2.loadDefaults_ASD(X, Y, D, obj);
%     scoreObj = reg2.loadDefaultScoreObj('rsq', obj.isLinReg);
%     obj = reg2.fitAndScore(X, Y, obj, scoreObj);
% 

    % remove empty trials
    inds = isnan(Y);
    X = X(~inds,:,:);
    Y = Y(~inds,:);
    obj.foldinds = obj.foldinds(~inds);

    % fit hyperparameters
    if isfield(obj, 'hyperObj')
        if obj.fitIntercept
            Yc = Y - mean(Y,1);
        else
            Yc = Y;
        end
        obj.hyper = obj.hyperObj.fitFcn(X, Yc, obj.hyperObj.fitFcnArgs{:});
    end

    % fit weights
    [obj.mu, obj.b] = reg2.fitWeights(X, Y, obj);
    obj.w = [obj.mu; obj.b];

    % score
    [scores, ws, scoreDev] = reg2.cvFitScores(X, Y, obj, scoreObj);
    obj.w_cv = ws;
    obj.scores = scores';
    obj.score_dev = scoreDev;
    obj.score_cvMean = mean(obj.scores);
    obj.score_cvStd = std(obj.scores);
    obj.score = obj.score_cvMean;

end

