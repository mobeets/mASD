function fitopts = fitMinNegLogEvi(hyper0, D)
% given a starting hyperparameter, find the hyperparameter and kernel
%   that maximizes the evidence (numerically)
    fitopts.fitIntercept = true;
    fitopts.centerX = false;
    fitopts.hyperFcn = @asd.gauss.optMinNegLogEvi;
    fitopts.hyperFcnArgs = {D, hyper0, true, false};
    fitopts.muFcn = @asd.gauss.calcMAP;
    fitopts.muFcnArgs = {D};
end
