function v = rsq(A, B)
    assert(isequal(size(A), size(B)));
    if size(A,1) == 1
        A = A'; B = B';
    end
    top = A - B;
    bot = B - mean(B);
    v = 1 - (top'*top)/(bot'*bot);
end
