function hyperObj = getHyperObj_grid(X, Y, obj, scoreObj)
    hyperObj.name = 'grid';
    
    % define grid
    lbs = [-10 -1 -1]; ubs = [10 6 6]; ns = 7*ones(1,3);
    hypergrid = tools.gridCartesianProduct(lbs, ubs, ns);
    isLog = [false true true];
    isLog = repmat(isLog, size(hypergrid,1), 1);
    hypergrid = isLog.*(exp(hypergrid)) + (1-isLog).*hypergrid;

    % set cross-val fold inds
    nfolds = 5;
%     [~, foldinds] = reg.trainAndTestKFolds(X, Y, nfolds);
    foldinds = obj.foldinds;

    hyperObj.fitFcn = @reg.cvBestHyperGridScore;
    hyperObj.fitFcnArgs = {foldinds, hypergrid, obj, scoreObj};

    hyperObj.opts.nfolds = nfolds;
    hyperObj.opts.foldinds = foldinds;
    hyperObj.opts.hypergrid = hypergrid;
end
