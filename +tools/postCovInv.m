function v = postCovInv(RegInv, XX, ssq)
    v = XX/ssq + RegInv;
end
