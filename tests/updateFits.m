function updateFits(fname, data, MAP, ML, scoreFcn, isLinReg)
    % verify erasing of previous results
    if ~checkContinue()
        return;
    end
    
    [D, hypergrid, ASD] = runFits(data, MAP, ML, scoreFcn, isLinReg, 'ASD');
    [~, ~, ML] = runFits(data, MAP, ML, scoreFcn, isLinReg, 'ML');
    [~, ~, ASD_m] = runFits(data, MAP, ML, scoreFcn, isLinReg, 'ASD_mother');
    [~, ~, ASD_gs] = runFits(data, MAP, ML, scoreFcn, isLinReg, 'ASD_gs');
    [~, ~, ASD_gs_m] = runFits(data, MAP, ML, scoreFcn, isLinReg, 'ASD_gs_mother');
    
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
    
    data.ASD_m = ASD_m;
    data.ASD_gs_m = ASD_gs_m;
    
    save(fname, '-struct', 'data');
end
