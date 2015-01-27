function v = rsq(A, B)
    top = A - B;
    bot = B - mean(B);
    v = 1 - (top'*top)/(bot'*bot);
end
