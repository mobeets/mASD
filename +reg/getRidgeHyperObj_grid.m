function hyperObj = getRidgeHyperObj_grid(X, Y, obj, scoreObj)
    hyperObj.name = 'ridge_grid';
    
    % define grid
    lbs = 1e-3; ubs = 1e-3; ns = 1;
    hypergrid = tools.gridCartesianProduct(lbs, ubs, ns);

    % set cross-val fold inds
    nfolds = 5;
    foldinds = obj.foldinds;

    hyperObj.fitFcn = @reg.cvHyperFitScores;
%     hyperObj.fitFcnArgs = {foldinds, hypergrid, obj, scoreObj};

    hyperObj.nfolds = nfolds;
    hyperObj.foldinds = foldinds;
    hyperObj.hypergrid = hypergrid;
    obj.hyperObj = hyperObj;
    hyperObj.fitFcnArgs = {obj, scoreObj};
end
