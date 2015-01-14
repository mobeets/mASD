function [mu, b, hyper] = fitMAP(X, Y, hyper0, D)
    fitopts.fitIntercept = true;
    fitopts.hyperFcn = @(X, Y, hyper) hyper;
    fitopts.hyperFcnArgs = {hyper0};
    fitopts.muFcn = @asd.bern.calcMAP;
    fitopts.muFcnArgs = {D};
    [mu, b, hyper] = reg.fitHypersAndWeights(X, Y, fitopts);    
end
