function M = linearASDStruct(D, llstr, fitstr, opts)
    if nargin < 4
        opts = struct();
    end
    if nargin < 3
        fitstr = '';
    end
    if nargin < 2
        llstr = 'gauss';
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
    M.mapFcn = @(hyper0) makeMapFcn(hyper0, D, fitstr, opts);

end

function fcnopts = makeMapFcn(hyper0, D, fitstr, opts)
% 
% given a hyperparameter, calculate the MAP estimate
%   with gaussian likelihood (closed form)
% 
    fcnopts.fitIntercept = true;
    fcnopts.centerX = false;
    if strcmpi(fitstr, 'evi')
        fcnopts.hyperFcn = @asd.gauss.optMinNegLogEvi;
        fcnopts.hyperFcnArgs = {D, hyper0, true, false};
    else
        fcnopts.hyperFcn = @(X, Y, hyper) hyper;
        fcnopts.hyperFcnArgs = {hyper0};
    end
    if strcmpi(fitstr, 'bilinear')
        fcnopts.muFcn = @(X, Y, hyper, D) reg.calcBilinear(X, Y, ...
            @asd.gauss.calcMAP, {hyper, D}, @ml.calcGaussML, {}, opts);
    else
        fcnopts.muFcn = @asd.gauss.calcMAP;
    end
    fcnopts.muFcnArgs = {D};
end
