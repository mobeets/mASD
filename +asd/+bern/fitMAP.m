function fitopts = fitMAP(hyper0, D)
    fitopts.fitIntercept = true;
    fitopts.centerX = false;
    fitopts.hyperFcn = @(X, Y, hyper) hyper;
    fitopts.hyperFcnArgs = {hyper0};
    fitopts.muFcn = @asd.bern.calcMAP;
    fitopts.muFcnArgs = {D};
end
