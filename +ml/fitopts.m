function opts = fitopts(llstr)
    opts.fitIntercept = true;
    opts.centerX = false;
    opts.hyperFcn = @(X, Y, hyper) hyper;
    opts.hyperFcnArgs = {nan};
    if strcmp(llstr, 'gauss')
        opts.muFcn = @ml.calcGaussML;
    elseif strcmp(llstr, 'bern')
        opts.muFcn = @ml.calcBernML;
    end
    opts.muFcnArgs = {};  
end
