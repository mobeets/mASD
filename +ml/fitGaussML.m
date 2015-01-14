function [wML, b, hyper] = fitGaussML(X, Y, ~)
    fitopts.fitIntercept = true;
    fitopts.hyperFcn = @(X, Y, hyper) hyper;
    fitopts.hyperFcnArgs = {nan};
    fitopts.muFcn = @ml.calcGaussML;
    fitopts.muFcnArgs = {};
    [wML, b, hyper] = reg.fitHypersAndWeights(X, Y, fitopts);    
end
