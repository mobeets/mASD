function obj = fitASD(X, Y, D, obj)
% 
% obj
%   .llstr - likelihood string; either 'gauss', 'bern', or 'poiss'
%   .predictionFcn() = @(X, w) ...;
%   .foldinds
%   .hyperObj
%     .fitFcn() = @(X, Y, D, obj.hyperObj.fitFcnArgs{:}) ...;
%     .fitFcnArgs = {...};
%   .scoreObj
%     .name
%     .scoreFcn() = @(X, Y, w, obj.scoreObj.scoreFcnArgs{:})
%     .scoreFcnArgs = {...};
% 
    obj = loadDefaults(X, Y, D, obj);
    
    % remove empty trials
    inds = isnan(Y);
    X = X(~inds,:,:);
    Y = Y(~inds,:);
    foldinds = obj.foldinds(~inds);

    % fit hyperparameters
    obj.hyper = obj.hyperObj.fitFcn(X, Y, D, obj.hyperObj.fitFcnArgs{:});

    % using hyper, fit weights to each fold of foldinds
    obj = asd.fitHandle2(obj.llstr, obj.hyper, D);
    [mu, b] = reg.fitWeights(X, Y, obj);
    obj.w = [mu; b]; obj.mu = mu; obj.b = b;

    % cross-validation for scores
    trials = reg.trainAndTestKFolds(X, Y, nan, foldinds);
    nfolds = numel(trials);
    ws = cell(nfolds, 1);
    obj.scores = nan(nfolds, 1);
    for ii = 1:nfolds
        ctrials = trials(ii);
        [mu, b] = reg.fitWeights(ctrials.x_train, ctrials.y_train, obj);
        ws{ii} = [mu; b];
        obj.scores(ii) = obj.scoreObj.scoreFcn(ctrials.x_test, ...
            ctrials.y_test, ws{ii}, obj.scoreObj.scoreFcnArgs{:});
    end
    obj.score_dev = nan;
    obj.score_cvMean = mean(obj.scores);
    obj.score_cvStd = std(obj.scores);
    obj.score = obj.score_cvMean;

end

function obj = loadDefaults(X, Y, ~, obj)
    if ~isfield(obj, 'llstr')
        if numel(unique(Y)) == 2
            obj.llstr = 'bern';
        else
            obj.llstr = 'gauss';
        end
    end
    if ~isfield(obj, 'predictionFcn')
        if strcmp(obj.llstr, 'gauss')
            obj.predictionFcn = @(X, w) tools.ifNecessaryAddDC(X,w)*w;
        else
            obj.predictionFcn = @(X, w) tools.logistic(...
                tools.ifNecessaryAddDC(X,w)*w);
        end
    end
    if ~isfield(obj, 'foldinds')
        obj.nfolds = 5;
        [~, foldinds] = reg.trainAndTestKFolds(X, Y, obj.nfolds);
        obj.foldinds = foldinds;
    end
    if ~isfield(obj, 'hyperObj')
        if strcmp(obj.llstr, 'gauss')
            hyperObj.fitFcn = @asd.gauss.optMinNegLogEvi;
            hyperObj.opts = tools.updateOptsWithDefaults(hyperObj.opts, ...
                {'gradObj', 'fullTemporalSmoothing'}, ...
                {false, false});
            hyperObj.fitFcnArgs = {hyperObj.opts.hyper0, ...
                hyperObj.opts.gradObj, hyperObj.opts.fullTemporalSmoothing};            
        else
%           grid!
            return;
        end
        obj.hyperObj = hyperObj;
    end
    if ~isfield(obj, 'scoreObj')
        if strcmp(obj.llstr, 'gauss')
            rsqFcn = @(X, Y, w) tools.rsq(obj.predictionFcn(X, w), Y);
            scoreObj.name = 'rsq';
            scoreObj.scoreFcn = rsqFcn;
            scoreObj.scoreFcnArgs = {};
        else
            correctFcn = @(X, Y, w) round(obj.predictionFcn(X, w)) == Y;
            pctCorrectFcn = @(X, Y, w) sum(correctFcn(X, Y, w)) / numel(Y);
            scoreObj.name = 'pctCorrect';
            scoreObj.scoreFcn = pctCorrectFcn;
            scoreObj.scoreFcnArgs = {};
        end
        obj.scoreObj = scoreObj;
    end
end
