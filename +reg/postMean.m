function v = postMean(SigmaInv, XY, ssq)
    v = (SigmaInv \ XY)/ssq;
end
