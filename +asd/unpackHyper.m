function [ro, ssq, deltas] = unpackHyper(hyper)
    ro = hyper(1);
    ssq = hyper(2);
    deltas = hyper(3:end);
end
