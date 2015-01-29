function [D, hypergrid, ASD, ML, ASD_gs] = runFits(data, M, mlFcn, isLinReg)

    % test distance matrix construction
    D = asd.sqdist.spaceTime(data.Xxy, data.ns, data.nt);

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
    [X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(data.X, data.Y, nan, data.foldinds);

    % test ASD
    [scores, hyprs, mus] = reg.cvScoreGrid(X_train, Y_train, X_test, ...
        Y_test, M.mapFcn, M.rsqFcn, hypergrid, {}, {});
    ASD.scores = scores;
    ASD.hyprs = hyprs;
    ASD.mus = mus;

    % test ML
    [scores, ~, mus] = reg.cvScoreGrid(X_train, Y_train, X_test, ...
        Y_test, mlFcn, M.rsqFcn, [nan nan nan], {}, {});
    ML.scores = scores;
    ML.mus = mus;

    % test ASD grid search
    [scores, hyprs, mus] = reg.cvScoreGridSearch(X_train, Y_train, X_test, ...
        Y_test, M.mapFcn, M.rsqFcn, lbs, ubs, ns, {}, {}, isLog);
    ASD_gs.scores = scores;
    ASD_gs.hyprs = hyprs;
    ASD_gs.mus = mus;

end
