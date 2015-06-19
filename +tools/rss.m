function v = rss(A, B)
    assert(isequal(size(A), size(B)));
    if size(A,1) == 1
        A = A'; B = B';
    end
    v = (A-B)'*(A-B);
end
