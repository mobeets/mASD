function fitopts = fitMinNegLogEvi(hyper0, D)
% given a starting hyperparameter, find the hyperparameter and kernel
%   that maximizes the evidence (numerically)
    fitopts.fitIntercept = true;
    fitopts.hyperFcn = @asd.bern.optMinNegLogEvi;
    fitopts.hyperFcnArgs = {hyper0, D, true};
    fitopts.muFcn = @asd.bern.calcMAP;
    fitopts.muFcnArgs = {D};
end
