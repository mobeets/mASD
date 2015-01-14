function [mu, b, hyper] = fitMinNegLogEvi(X, Y, hyper0, D)
% given a starting hyperparameter, find the hyperparameter and kernel
%   that maximizes the evidence (numerically)
    fitopts.fitIntercept = true;
    fitopts.hyperFcn = @asd.gauss.optMinNegLogEvi;
    fitopts.hyperFcnArgs = {D, hyper0, true, false};
    fitopts.muFcn = @asd.gauss.calcMAP;
    fitopts.muFcnArgs = {D};
    [mu, b, hyper] = reg.fitHypersAndWeights(X, Y, fitopts);
end


