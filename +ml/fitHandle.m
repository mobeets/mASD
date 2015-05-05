function opts = fitHandle(llstr)    
    opts.hyperFcn = @(X, Y, hyper) hyper;
    opts.hyperFcnArgs = {nan};
    if strcmp(llstr, 'gauss')
        opts.muFcn = @ml.calcGaussML;
    elseif strcmp(llstr, 'bern')
        opts.muFcn = @ml.calcBernML;
    elseif strcmp(llstr, 'poiss')
        opts.muFcn = @ml.calcPoissML;
    end
    opts.muFcnArgs = {};
    opts.fitIntercept = true;
    opts.centerX = false;
end
