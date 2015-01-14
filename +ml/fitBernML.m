function [mu, b, hyper] = fitBernML(X, Y, ~)
    fitopts.fitIntercept = true;
    fitopts.hyperFcn = @(X, Y, hyper) hyper;
    fitopts.hyperFcnArgs = {nan};
    fitopts.muFcn = @ml.calcBernML;
    fitopts.muFcnArgs = {};
    [mu, b, hyper] = reg.fitHypersAndWeights(X, Y, fitopts);    
end
