function [XX, XY, YY, p, q, Reg] = gaussInit(X, Y, Ds, hyper)
    [ro, ssq, deltas] = asd.unpackHyper(hyper);
    XX = X'*X;
    XY = X'*Y;
    YY = Y'*Y;
    [p, q] = size(X);
    Reg = asd.prior(ro, Ds, deltas);
end