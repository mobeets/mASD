function mu = rankKApproximation(mu, k)
% function mu = rankKApproximation(fcn, fcnArgs, k)
% 
% returns rank-k approximation of return value of mu
% 
    [u,s,v] = svds(mu, k);
    mu = u*s*v';
end
