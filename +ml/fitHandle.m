function opts = fitHandle(llstr)    
    opts.hyperFcn = @(X, Y, hyper) hyper;
    opts.hyperFcnArgs = {nan};
    opts.fitIntercept = true;
    if strcmp(llstr, 'gauss')
        opts.muFcn = @ml.calcGaussML;
    elseif strcmp(llstr, 'bern')
        opts.muFcn = @ml.calcBernML;
        opts.fitIntercept = false; % only fitting 0/1
    elseif strcmp(llstr, 'poiss')
        opts.muFcn = @ml.calcPoissML;
    end
    opts.muFcnArgs = {};    
    opts.centerX = false;
end
