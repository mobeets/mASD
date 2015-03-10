function M = logisticASDStruct(D, fitstr, opts)
    if nargin < 3
        opts = struct();
    end
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

    M.mapFcn = @(hyper0) makeMapFcn(hyper0, D, fitstr, opts);

end

function fcnopts = makeMapFcn(hyper0, D, fitstr, opts)
    if strcmpi(fitstr, 'evi')
        fcnopts.hyperFcn = @asd.bern.optMinNegLogEvi;
        fcnopts.hyperFcnArgs = {hyper0, D, true};
    else
        fcnopts.hyperFcn = @(X, Y, hyper) hyper;
        fcnopts.hyperFcnArgs = {hyper0};
    end
    fcnopts.fitIntercept = true;
    fcnopts.centerX = false;
    if strcmpi(fitstr, 'bilinear')
        fcnopts.muFcn = @(X, Y, hyper, D) reg.calcBilinear(X, Y, ...
            @asd.bern.calcMAP, {hyper, D}, @ml.calcBernML, {}, opts);
    else
        fcnopts.muFcn = @asd.bern.calcMAP;
    end
    fcnopts.muFcnArgs = {D};
end
