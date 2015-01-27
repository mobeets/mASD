function opts = fitopts(hyper0, D, fitstr)
% given a hyperparameter, calculate the MAP estimate
%   with gaussian likelihood (closed form)
    if nargin < 3
        fitstr = '';
    end
    opts.fitIntercept = true;
    opts.centerX = false;
    if strcmpi(fitstr, 'evi')
        opts.hyperFcn = @asd.gauss.optMinNegLogEvi;
        opts.hyperFcnArgs = {D, hyper0, true, false};
    else
        opts.hyperFcn = @(X, Y, hyper) hyper;
        opts.hyperFcnArgs = {hyper0};
    end
    opts.muFcn = @asd.gauss.calcMAP;
    opts.muFcnArgs = {D};
end
