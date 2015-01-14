function [XX, XY, YY, p, q, Reg] = init(X, Y, Ds, hyper)
    [ro, ~, deltas] = asd.unpackHyper(hyper);
    XX = X'*X;
    XY = X'*Y;
    YY = Y'*Y;
    [p, q] = size(X);
    Reg = asd.prior(ro, Ds, deltas);
end