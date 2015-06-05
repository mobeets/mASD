function [mu, b] = fitWeights(X, Y, opts)
% function [mu, b] = fitWeights(X, Y, opts)
% 
% X, Y - return best mu,b s.t. Y ~ X*mu + b
% opts is struct
%   - opts.fitIntercept
%   - opts.centerX
%   - opts.muFcn
%   - opts.muFcnArgs
% 
    [X, Y, X_mean, Y_mean] = reg.centerData(X, Y, ...
        opts.fitIntercept, opts.centerX);
    mu = opts.muFcn(X, Y, opts.muFcnArgs{:});
    b = reg.setIntercept(X_mean, Y_mean, mu, opts.fitIntercept, ...
        opts.predictionFcn);
end
