function obj = fitHandle(hyper0, D, llstr, fitstr, opts)
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
        obj = linearFitHandle(hyper0, D, fitstr, opts);
    elseif strcmpi(llstr, 'poiss')
        obj = linearFitHandle(hyper0, D, fitstr, opts);
    end
    obj.fitIntercept = true;
    obj.centerX = false;
end

function obj = linearFitHandle(hyper0, D, fitstr, opts)
    if strcmpi(fitstr, 'evi')
        obj.hyperFcn = @asd.gauss.optMinNegLogEvi;
        obj.hyperFcnArgs = {D, hyper0, true, false};
    else
        obj.hyperFcn = @(X, Y, hyper) hyper;
        obj.hyperFcnArgs = {hyper0};
    end
    if strcmpi(fitstr, 'bilinear')
        obj.muFcn = @(X, Y, hyper, D) reg.calcBilinear(X, Y, ...
            @asd.gauss.calcMAP, {hyper, D}, @ml.calcGaussML, {}, opts);
    else
        obj.muFcn = @asd.gauss.calcMAP;
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
        fcnopts.muFcn = @(X, Y, hyper, D) reg.calcBilinear(X, Y, ...
            @asd.bern.calcMAP, {hyper, D}, @ml.calcBernML, {}, opts);
    else
        fcnopts.muFcn = @asd.bern.calcMAP;
    end
    fcnopts.muFcnArgs = {D};
end
