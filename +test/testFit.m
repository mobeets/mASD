function testFit(data, M, mlFcn, isLinReg)

    % test distance matrix construction
    D = asd.sqdist.spaceTime(data.Xxy, data.ns, data.nt);
    assert(all(D(:) == data.D(:)));

    isLog = true;
    lbs = [-3, -2, -5];
    ubs = [3, 10, 10];
    ns = 5*ones(1,3);

    % test hypergrid
    hypergrid = asd.makeHyperGrid(lbs, ubs, ns, data.ndeltas, false, isLinReg);
    assert(all(hypergrid(:) == data.hypergrid(:)));

    [X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(data.X, data.Y, nan, data.foldinds);

    % test ASD
    [scores, hyprs, mus] = reg.scoreCVGrid(X_train, Y_train, X_test, ...
        Y_test, M.mapFcn, M.rsqFcn, hypergrid, M.mapFcnOpts, {});
    mus = cell2mat(mus);
    mus1 = cell2mat(data.ASD.mus);
    assert(all(scores(:) == data.ASD.scores(:)));
    assert(all(hyprs(:) == data.ASD.hyprs(:)));
    assert(all(mus(:) == mus1(:)));

    % test ML
    [scores, ~, mus] = reg.scoreCVGrid(X_train, Y_train, X_test, ...
        Y_test, mlFcn, M.rsqFcn, [nan nan nan], {}, {});
    mus = cell2mat(mus);
    mus1 = cell2mat(data.ML.mus);
    assert(all(scores(:) == data.ML.scores(:)));
    assert(all(mus(:) == mus1(:)));

    % test ASD grid search
    [scores, hyprs, mus] = reg.scoreCVGridSearch(X_train, Y_train, X_test, ...
        Y_test, M.mapFcn, M.rsqFcn, lbs, ubs, ns, M.mapFcnOpts, {}, isLog);
    mus = cell2mat(mus);
    mus1 = cell2mat(data.ASD_gs.mus);
    scores = cell2mat(scores);
    scores1 = cell2mat(data.ASD_gs.scores);
    hyprs = cell2mat(hyprs);
    hyprs1 = cell2mat(data.ASD_gs.hyprs);
    assert(all(scores(:) == scores1(:)));
    assert(all(hyprs(:) == hyprs1(:)));
    assert(all(mus(:) == mus1(:)));
end
    