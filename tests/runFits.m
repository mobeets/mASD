function [D, hypergrid, obj] = runFits(data, M, mlFcn, isLinReg, fit)

    % test distance matrix construction
    D = asd.sqdist.spaceTime(data.Xxy, data.ns, data.nt);

    isLog = true;
    if isLinReg
        lbs = [-3 -2 -5 -5];
        ubs = [3 10 10 10];
        ns = 5*ones(1,4);
        scFcn = M.rsqFcn;
    else
        lbs = [-3 -5 -5];
        ubs = [3 10 10];
        ns = 5*ones(1,3);
        scFcn = M.pseudoRsqFcn;
    end

    % test hypergrid
    hypergrid = exp(tools.gridCartesianProduct(lbs, ubs, ns));
    trials = reg.trainAndTestKFolds(data.X, data.Y, nan, data.foldinds);

    % test ASD
    if strcmpi(fit, 'ASD')        
        [scores, hyprs, mus] = reg.cvScoreGrid(trials, M.mapFcn, scFcn, ...
            hypergrid, {}, {});
        obj.scores = scores;
        obj.hyprs = hyprs;
        obj.mus = mus;
        
    elseif strcmpi(fit, 'ASD_mother')
        obj = reg.cvMaxScoreGrid(data.X, data.Y, hypergrid, M.mapFcn, ...
            {}, scFcn, {}, data.foldinds, data.evalinds);

    % test ML
    elseif strcmpi(fit, 'ML')
        [scores, ~, mus] = reg.cvScoreGrid(trials, mlFcn, scFcn, ...
            [nan nan nan], {}, {});
        obj.scores = scores;
        obj.mus = mus;

    % test ASD grid search parent
    elseif strcmpi(fit, 'ASD_gs_mother')
        obj = reg.cvMaxScoreGridSearch(data.X, data.Y, lbs, ubs, ns, ...
            M.mapFcn, {}, scFcn, {}, data.foldinds, data.evalinds, isLog);

    % test ASD grid search
    elseif strcmpi(fit, 'ASD_gs')
        [scores, hyprs, mus] = reg.cvScoreGridSearch(trials, M.mapFcn, ...
            scFcn, lbs, ubs, ns, {}, {}, isLog);
        obj.scores = scores;
        obj.hyprs = hyprs;
        obj.mus = mus;

    else
        obj = '';
    end
end
