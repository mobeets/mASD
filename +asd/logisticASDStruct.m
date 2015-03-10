function M = logisticASDStruct(D, fitstr)
    if nargin < 2
        fitstr = '';
    end
    
    M.llFcn0 = @(x, y, w, hyper) ...
        -tools.neglogli_bernoulliGLM(w, tools.ifNecessaryAddDC(x, w), y);
    M.llFcn = @(trials, w, hyper) ...
        M.llFcn0(trials.x_test, trials.y_test, w, hyper);
    
    M.rsqFcn = @(trials, w, hyper) ...
        tools.rsq(tools.logistic(...
            tools.ifNecessaryAddDC(trials.x_test,w)*w), trials.y_test);

    M.pseudoRsqFcn = @(trials, w, hyper) ...
        tools.pseudoRsq(...
            M.llFcn0(trials.x_test, trials.y_test, w, hyper), ... % actual model
            0, ... % saturated model
            M.llFcn0(mean(trials.y_train)*ones(size(trials.y_test,1),1), ...
                trials.y_test, 1, hyper)); % null model
%             M.llFcn0(trials.y_test, trials.y_test, 1, hyper), ...  % saturated model

    M.mapFcn = @(hyper0) fitopts(hyper0, D, fitstr);

end

function opts = fitopts(hyper0, D, fitstr)
    if nargin < 3
        fitstr = '';
    end
    if strcmpi(fitstr, 'evi')
        opts.hyperFcn = @asd.bern.optMinNegLogEvi;
        opts.hyperFcnArgs = {hyper0, D, true};
    else
        opts.hyperFcn = @(X, Y, hyper) hyper;
        opts.hyperFcnArgs = {hyper0};
    end
    opts.fitIntercept = true;
    opts.centerX = false;
    if strcmpi(fitstr, 'bilinear')
        opts.muFcn = @(X, Y, hyper, D) asd.reg.calcBilinear(X, Y, ...
            asd.bern.calcMAP, {hyper, D}, ml.calcBernML, {}, struct());
    else
        opts.muFcn = @asd.bern.calcMAP;
    end
    opts.muFcnArgs = {D};
end
