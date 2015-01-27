function [mu, b, hyper] = fitHypersAndWeights(X, Y, opts)
% opts is struct
%   - opts.fitIntercept
%   - opts.centerX
%   - opts.hyperFcn
%   - opts.hyperFcnArgs
%   - opts.muFcn
%   - opts.muFcnArgs
% 
    [X, Y, X_mean, Y_mean] = reg.centerData(X, Y, opts.fitIntercept, opts.centerX);
    hyper = opts.hyperFcn(X, Y, opts.hyperFcnArgs{:});
    mu = opts.muFcn(X, Y, hyper, opts.muFcnArgs{:});
    b = reg.setIntercept(X_mean, Y_mean, mu, opts.fitIntercept);
end
