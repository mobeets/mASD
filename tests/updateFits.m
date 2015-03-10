function updateFits(fname, data, M, mlFcn, isLinReg)
    % verify erasing of previous results
    if ~checkContinue()
        return;
    end
    
    [D, hypergrid, ASD, ML, ASD_gs] = runFits(data, M, mlFcn, isLinReg);
    
    data.D = D;
    data.hypergrid = hypergrid;

    data.ASD.scores = ASD.scores;
    data.ASD.hyprs = ASD.hyprs;
    data.ASD.mus = ASD.mus;

    data.ML.scores = ML.scores;
    data.ML.mus = ML.mus;

    data.ASD_gs.scores = ASD_gs.scores;
    data.ASD_gs.hyprs = ASD_gs.hyprs;
    data.ASD_gs.mus = ASD_gs.mus;
    
    save(fname, '-struct', 'data');
end
