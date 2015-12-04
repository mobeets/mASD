function hyperObj = getHyperObj_gaussARD(wML, pRdg)
    if nargin < 2
        pRdg = nan;
    end
    if nargin < 1
        wML = nan;
    end
    hyperObj.name = 'evidence';
    hyperObj.fitFcn = @ml.optMinNegLogEvi_ARD;
    hyperObj.opts.gradObj = false;
    
    hyperObj.maxiters = 1e4;
    hyperObj.thresh = 1e-6;
    hyperObj.fitFcnArgs = {hyperObj.maxiters, hyperObj.thresh, wML, pRdg};
    
end
