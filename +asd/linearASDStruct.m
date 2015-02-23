function M = linearASDStruct(D, llstr, fitstr)
    if nargin < 2
        llstr = 'gauss';
    end
    if nargin < 3
        fitstr = '';
    end
    
    addones = @(X) [X ones(size(X,1),1)];
    if strcmp(llstr, 'poiss')
        M.llFcn = @(trials, w, hyper) -tools.neglogli_poissGLM(...
            w, addones(trials.x_test), trials.y_test, @tools.expfun);
    elseif strcmp(llstr, 'gauss')
        M.llFcn = @(trials, w, hyper) asd.gauss.logLikelihood(...
            trials.y_test, addones(trials.x_test), w, hyper(2));
    end
    M.rsqFcn = @(trials, w, hyper) tools.rsq(addones(trials.x_test)*w, trials.y_test);
    M.mapFcn = @(hyper0) fitopts(hyper0, D, fitstr);

end

function opts = fitopts(hyper0, D, fitstr)
% given a hyperparameter, calculate the MAP estimate
%   with gaussian likelihood (closed form)
    if nargin < 3
        fitstr = '';
    end
    opts.fitIntercept = true;
    opts.centerX = false;
    if strcmpi(fitstr, 'evi')
        opts.hyperFcn = @asd.gauss.optMinNegLogEvi;
        opts.hyperFcnArgs = {D, hyper0, true, false};
    else
        opts.hyperFcn = @(X, Y, hyper) hyper;
        opts.hyperFcnArgs = {hyper0};
    end
    opts.muFcn = @asd.gauss.calcMAP;
    opts.muFcnArgs = {D};
end
