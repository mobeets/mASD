function [D, hypergrid, obj] = runFits(data, MAP, ML, scoreFcn, ...
    isLinReg, fitType)

    % test distance matrix construction
    D = asd.sqdist.spaceTime(data.Xxy, data.nt);

    isLog = true;
    if isLinReg
        lbs = [-3 -2 -5 -5];
        ubs = [3 10 10 10];
        ns = 5*ones(1,4);
    else
        lbs = [-3 -5 -5];
        ubs = [3 10 10];
        ns = 5*ones(1,3);
    end

    % test hypergrid
    hypergrid = exp(tools.gridCartesianProduct(lbs, ubs, ns));
    hyperOpts = struct('lbs', lbs, 'ubs', ubs, 'ns', ns, 'isLog', isLog);
    trials = reg.trainAndTestKFolds(data.X, data.Y, nan, data.foldinds);

    % test ASD
    if strcmpi(fitType, 'ASD')        
        [scores, hyprs, mus] = reg.cvScoreGrid(trials, MAP, ...
            scoreFcn, hypergrid);
        obj.scores = scores;
        obj.hyprs = hyprs;
        obj.mus = mus;   

    % test ML
    elseif strcmpi(fitType, 'ML')
        [scores, ~, mus] = reg.cvScoreGrid(trials, ML, scoreFcn, ...
            [nan nan nan]);
        obj.scores = scores;
        obj.mus = mus;    

    % test ASD grid search
    elseif strcmpi(fitType, 'ASD_gs')
        [scores, hyprs, mus] = reg.cvScoreGridSearch(trials, MAP, ...
            scoreFcn, hyperOpts);
        obj.scores = scores;
        obj.hyprs = hyprs;
        obj.mus = mus;
        
    % test ASD grid search parent
    elseif strcmpi(fitType, 'ASD_gs_mother')
        obj = reg.cvMaxScoreGrid(data.X, data.Y, MAP, scoreFcn, ...
            nan, data.foldinds, data.evalinds, 'grid-search', hyperOpts);
        
     elseif strcmpi(fitType, 'ASD_mother')
        obj = reg.cvMaxScoreGrid(data.X, data.Y, MAP, scoreFcn, ...
            hypergrid, data.foldinds, data.evalinds, 'grid');

    else
        obj = '';
    end
end
