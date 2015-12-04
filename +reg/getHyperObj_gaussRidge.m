function hyperObj = getHyperObj_gaussRidge(wML)
    if nargin < 1
        wML = nan;
    end
    hyperObj.name = 'evidence';
    hyperObj.fitFcn = @ml.optMinNegLogEvi_ridge;
    hyperObj.opts.gradObj = false;
    
    hyperObj.maxiters = 1e4;
    hyperObj.thresh = 1e-6;
    hyperObj.fitFcnArgs = {hyperObj.maxiters, hyperObj.thresh, wML};
    
end
