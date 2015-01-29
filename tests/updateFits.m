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

function cont = checkContinue()
    cont = true;
    orig_state = warning;   
    warning('off', 'backtrace');
    warning('This will erase all test data and replace with new results.');
    warning(orig_state);
    m = input('Continue? ','s');
    if ~strcmpi(m, 'yes')
        disp('That''s what I thought.');
        cont = false;
    end
end
