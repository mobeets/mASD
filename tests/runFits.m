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
    mapFcns = struct('fitFcn', M.mapFcn, 'fitFcnOpts', {{}}, ...
        'scoreFcn', scFcn, 'scoreFcnOpts', {{}});
    mlFcns = struct('fitFcn', mlFcn, 'fitFcnOpts', {{}}, ...
        'scoreFcn', scFcn, 'scoreFcnOpts', {{}});

    % test hypergrid
    hypergrid = exp(tools.gridCartesianProduct(lbs, ubs, ns));
    hyperOpts = struct('lbs', lbs, 'ubs', ubs, 'ns', ns, 'isLog', isLog);
    trials = reg.trainAndTestKFolds(data.X, data.Y, nan, data.foldinds);

    % test ASD
    if strcmpi(fit, 'ASD')        
        [scores, hyprs, mus] = reg.cvScoreGrid(trials, mapFcns, hypergrid);
        obj.scores = scores;
        obj.hyprs = hyprs;
        obj.mus = mus;
        
    elseif strcmpi(fit, 'ASD_mother')
        obj = reg.cvMaxScoreGrid(data.X, data.Y, mapFcns, hypergrid, ...
            data.foldinds, data.evalinds, 'grid');

    % test ML
    elseif strcmpi(fit, 'ML')
        [scores, ~, mus] = reg.cvScoreGrid(trials, mlFcns, [nan nan nan]);
        obj.scores = scores;
        obj.mus = mus;

    % test ASD grid search parent
    elseif strcmpi(fit, 'ASD_gs_mother')
        obj = reg.cvMaxScoreGrid(data.X, data.Y, mapFcns, nan, ...
            data.foldinds, data.evalinds, 'grid-search', hyperOpts);

    % test ASD grid search
    elseif strcmpi(fit, 'ASD_gs')
        [scores, hyprs, mus] = reg.cvScoreGridSearch(trials, mapFcns, ...
            hyperOpts);
        obj.scores = scores;
        obj.hyprs = hyprs;
        obj.mus = mus;

    else
        obj = '';
    end
end
