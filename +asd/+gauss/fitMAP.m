function fitopts = fitMAP(hyper0, D)
% given a hyperparameter, calculate the MAP estimate
%   with gaussian likelihood (closed form)
    fitopts.fitIntercept = true;
    fitopts.centerX = false;
    fitopts.hyperFcn = @(X, Y, hyper) hyper;
    fitopts.hyperFcnArgs = {hyper0};
    fitopts.muFcn = @asd.gauss.calcMAP;
    fitopts.muFcnArgs = {D};
end
