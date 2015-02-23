function M = logisticASDStruct(D, fitstr)
    if nargin < 2
        fitstr = '';
    end
    
    M.llFcn = @(trials, w, hyper) ...
        -tools.neglogli_bernoulliGLM(w, ...
            tools.ifNecessaryAddDC(trials.x_test, w), trials.y_test);
%         -tools.neglogli_bernoulliGLM(w(1:end-1), X_test, R_test);
    M.rsqFcn = @(trials, w, hyper) ...
        tools.rsq(tools.logistic(...
            tools.ifNecessaryAddDC(trials.x_test,w)*w), trials.r_test);
%         tools.rsq(tools.logistic(X_test*w(1:end-1) + w(end)), R_test);
    
    M.pseudoRsqFcn = @(trials, w, hyper) ...
        tools.pseudoRsq(...
            M.llFcn(trials.x_test, trials.y_test, w, hyper), ...
            M.llFcn(trials.y_test, trials.y_test, 1, hyper), ...  % saturated model
            M.llFcn(mean(trials.y_train)*ones(size(trials.y_test,1),1), ...
                trials.y_test, 1, hyper)); % null model

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
    opts.muFcn = @asd.bern.calcMAP;
    opts.muFcnArgs = {D};
end
