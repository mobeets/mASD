function opts = fitopts(hyper0, D, fitstr)
    if nargin < 3
        fitstr = '';
    end
    if strcmpi(fitstr, 'evi')
        opts.hyperFcn = @asd.bern.optMinNegLogEvi;
        opts.hyperFcnArgs = {hyper0, D, true};
    else
        opts.hyperFcn = @(X, Y, hyper) hyper;
        opts.hyperFcnArgs = {hyper0};
    end
    opts.fitIntercept = true;
    opts.centerX = false;
    opts.muFcn = @asd.bern.calcMAP;
    opts.muFcnArgs = {D};
end
