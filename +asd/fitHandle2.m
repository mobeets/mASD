function opts = fitHandle2(llstr, hyper, D, opts)
% 
% Inputs:
%     hyper - hyperparameter
%     D - squared distance matrix
%     llstr - ['bern', 'gauss', 'poiss']
% 
    if nargin < 4
        opts = struct();
    end
    opts = tools.updateOptsWithDefaults(opts, ...
        {'fitIntercept', 'centerX'}, {true, false});

    if strcmpi(llstr, 'bern')
        opts.muFcn = @asd.bern.calcMAP;        
    elseif strcmpi(llstr, 'gauss')
        opts.muFcn = @asd.gauss.calcMAP;
    elseif strcmpi(llstr, 'poiss')
        opts.muFcn = @asd.poiss.calcMAP;
    end
    opts.muFcnArgs = {hyper, D};
    opts.fitIntercept = fitOpts.fitIntercept;
    opts.centerX = fitOpts.centerX;
end
