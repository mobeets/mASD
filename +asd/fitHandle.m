function obj = fitHandle(hyper0, D, llstr, fitstr, opts)
% 
% Inputs:
%     hyper0 - hyperparameter to give to hyperFcn for optimization
%     D - squared distance matrix
%     llstr - ['bern', 'gauss', 'poiss']
%     fitstr - ['', 'evi', 'bilinear']
%       '' - (default)
%       'evi' - evidence optimization to choose hyperparameter
%       'bilinear' - assumes space and time are separable when fitting kernel
%     opts - for llstr 'bilinear'
% 
    if nargin < 5
        opts = struct();
    end
    if nargin < 4
        fitstr = '';
    end
    if strcmpi(llstr, 'bern')
        obj = logisticFitHandle(hyper0, D, fitstr, opts);
    elseif strcmpi(llstr, 'gauss')
        obj = linearFitHandle(hyper0, D, fitstr, @asd.gauss.calcMAP, opts);
    elseif strcmpi(llstr, 'poiss')
        assert(~strcmpi(fitstr, 'evi')); % not yet supported
        obj = linearFitHandle(hyper0, D, fitstr, @asd.poiss.calcMAP, opts);
    end
    obj.fitIntercept = true;
    obj.centerX = false;
end

function obj = linearFitHandle(hyper0, D, fitstr, llfcn, opts)
    if strcmpi(fitstr, 'evi')
        obj.hyperFcn = @asd.gauss.optMinNegLogEvi;
        obj.hyperFcnArgs = {D, hyper0, true, false};
    else
        obj.hyperFcn = @(X, Y, hyper) hyper;
        obj.hyperFcnArgs = {hyper0};
    end
    if strcmpi(fitstr, 'bilinear')
        fcns = @(hyper) struct('sFcn', llfcn, 'sFcnOpts', ...
            {{hyper, D}}, 'tFcn', @ml.calcGaussML, 'tFcnOpts', {{}});
        obj.muFcn = @(X, Y, hyper, D) reg.calcBilinear(X, Y, ...
            fcns(hyper), opts);
    else
        obj.muFcn = llfcn;
    end
    obj.muFcnArgs = {D};
end

function fcnopts = logisticFitHandle(hyper0, D, fitstr, opts)
    if strcmpi(fitstr, 'evi')
        fcnopts.hyperFcn = @asd.bern.optMinNegLogEvi;
        fcnopts.hyperFcnArgs = {hyper0, D, true};
    else
        fcnopts.hyperFcn = @(X, Y, hyper) hyper;
        fcnopts.hyperFcnArgs = {hyper0};
    end
    if strcmpi(fitstr, 'bilinear')
        fcns = @(hyper) struct('sFcn', @asd.bern.calcMAP, 'sFcnOpts', ...
            {{hyper, D}}, 'tFcn', @ml.calcBernML, 'tFcnOpts', {{}});
        fcnopts.muFcn = @(X, Y, hyper, D) reg.calcBilinear(X, Y, ...
            fcns(hyper), opts);
    else
        fcnopts.muFcn = @asd.bern.calcMAP;
    end
    fcnopts.muFcnArgs = {D};
end
