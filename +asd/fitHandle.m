function obj = fitHandle(hyper0, D, llstr, fitstr, opts, fitOpts)
% 
% Inputs:
%     hyper0 - hyperparameter to give to hyperFcn for optimization
%     D - squared distance matrix
%     llstr - ['bern', 'gauss', 'poiss']
%     fitstr - ['', 'evi', 'bilinear']
%       '' - (default)
%       'evi' - evidence optimization to choose hyperparameter
%       'bilinear' - assumes space and time are separable when fitting kernel
%     opts - for llstr 'bilinear' or fitstr 'evi'
% 
    if nargin < 6        
        fitOpts = struct();
    end
    fitOpts = updateOptsWithDefaults(fitOpts, ...
        {'fitIntercept', 'centerX'}, {true, false});
    if nargin < 5
        opts = struct();
    end
    if nargin < 4
        fitstr = '';
    end
    if strcmpi(llstr, 'bern')
        obj = logisticFitHandle(hyper0, D, fitstr, opts);
        obj.predictionFcn = @(X, w) tools.logistic(X*w);
    elseif strcmpi(llstr, 'gauss')
        obj = linearFitHandle(hyper0, D, fitstr, @asd.gauss.calcMAP, opts);
        obj.predictionFcn = @(X, w) X*w;
    elseif strcmpi(llstr, 'poiss')
        assert(~strcmpi(fitstr, 'evi')); % not yet supported
        obj = linearFitHandle(hyper0, D, fitstr, @asd.poiss.calcMAP, opts);
        obj.predictionFcn = @(X, w) X*w;
    end
    obj.fitIntercept = fitOpts.fitIntercept;
    obj.centerX = fitOpts.centerX;
end

function obj = linearFitHandle(hyper0, D, fitstr, mapFcn, opts)
    if strcmpi(fitstr, 'evi')
        obj.hyperFcn = @asd.gauss.optMinNegLogEvi;
        opts = updateOptsWithDefaults(opts, ...
            {'gradObj', 'fullTemporalSmoothing'}, ...
            {false, false});
        obj.hyperFcnArgs = {D, hyper0, ...
            opts.gradObj, opts.fullTemporalSmoothing};
    else
        obj.hyperFcn = @(X, Y, hyper) hyper;
        obj.hyperFcnArgs = {hyper0};
    end
    if strcmpi(fitstr, 'bilinear')
        fcns = @(hyper) struct('sFcn', mapFcn, 'sFcnOpts', ...
            {{hyper, D}}, 'tFcn', @ml.calcGaussML, 'tFcnOpts', {{}});
        obj.muFcn = @(X, Y, hyper, D) reg.calcBilinear(X, Y, ...
            fcns(hyper), opts);
    else
        obj.muFcn = mapFcn;
    end    
    obj.muFcnArgs = {D};
    % obj.muFcnArgs = {hyper0, D};
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
%     fcnopts.muFcnArgs = {hyper0, D};
    fcnopts.muFcnArgs = {D};
end

function opts = updateOptsWithDefaults(opts, names, vals)
    for ii = 1:numel(names)
        if ~isfield(opts, names{ii})
            opts.(names{ii}) = vals{ii};
        end
    end
end
