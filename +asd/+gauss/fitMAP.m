function [mu, b, hyper] = fitMAP(X, Y, hyper0, D)
% given a hyperparameter, calculate the MAP estimate
%   with gaussian likelihood (closed form)
    fitopts.fitIntercept = true;
    fitopts.hyperFcn = @(X, Y, hyper) hyper;
    fitopts.hyperFcnArgs = {hyper0};
    fitopts.muFcn = @asd.gauss.calcMAP;
    fitopts.muFcnArgs = {D};
    [mu, b, hyper] = reg.fitHypersAndWeights(X, Y, fitopts);
end
