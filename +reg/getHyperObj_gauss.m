function hyperObj = getHyperObj_gauss(D)
    hyperObj.name = 'evidence';
    hyperObj.fitFcn = @asd.gauss.optMinNegLogEvi;
    hyperObj.opts.gradObj = false;
    hyperObj.opts.fullTemporalSmoothing = false;
    hyperObj.fitFcnArgs = {D, nan, ...
        hyperObj.opts.gradObj, hyperObj.opts.fullTemporalSmoothing};            
end
