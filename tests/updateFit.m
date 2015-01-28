function updateFit(fname, data, M, mlFcn, isLinReg)
    % verify erasing of previous results
    if ~checkContinue()
        return;
    end
    
    % test distance matrix construction
    D = asd.sqdist.spaceTime(data.Xxy, data.ns, data.nt);
    data.D = D;

    isLog = true;
    lbs = [-3, -2, -5];
    ubs = [3, 10, 10];
    ns = 5*ones(1,3);

    % test hypergrid
    hypergrid = asd.makeHyperGrid(lbs, ubs, ns, data.ndeltas, false, isLinReg);
    data.hypergrid = hypergrid;

    [X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(data.X, data.Y, nan, data.foldinds);

    % test ASD
    [scores, hyprs, mus] = reg.scoreCVGrid(X_train, Y_train, X_test, ...
        Y_test, M.mapFcn, M.rsqFcn, hypergrid, M.mapFcnOpts, {});
    data.ASD.scores = scores;
    data.ASD.hyprs = hyprs;
    data.ASD.mus = mus;

    % test ML
    [scores, ~, mus] = reg.scoreCVGrid(X_train, Y_train, X_test, ...
        Y_test, mlFcn, M.rsqFcn, [nan nan nan], {}, {});
    data.ML.scores = scores;
    data.ML.mus = mus;

    % test ASD grid search
    [scores, hyprs, mus] = reg.scoreCVGridSearch(X_train, Y_train, X_test, ...
        Y_test, M.mapFcn, M.rsqFcn, lbs, ubs, ns, M.mapFcnOpts, {}, isLog);
    data.ASD_gs.scores = scores;
    data.ASD_gs.hyprs = hyprs;
    data.ASD_gs.mus = mus;
    
    save(fname, '-struct', 'data');
end

function stop = checkContinue()
    stop = false;
    orig_state = warning;   
    warning('off', 'backtrace');
    warning('This will erase all test data and replace with new results.');
    warning(orig_state);
    m = input('Continue? ','s');
    if ~strcmpi(m, 'yes')
        disp('That''s what I thought.');
        stop = false;
    end
end
