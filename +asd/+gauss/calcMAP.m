function mu = calcMAP(X, Y, hyper, D)
% function mu = calcMAP(X, Y, hyper, Ds)
% 
% fits full space-time weights using ASD, given fixed hyperparameter
% 
% X [ny x nw]
% Y [ny x 1]
% hyper [nh x 1] - hyperparams; hyper(3:4) controls space-time smoothing
% D [ns*nt x ns*nt x (nh-2)] - squared distance matrix between weights
% 
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    Reg = asd.prior(ro, D, deltas);
    [RegInv, B] = asd.invPrior(Reg);
    XB = X*B;
    [mu, ~] = tools.meanInvCov(XB'*XB, XB'*Y, RegInv, ssq);
    mu = B*mu; % map back to original basis
end
