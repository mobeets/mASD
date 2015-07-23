function v = rsq(Yh, Y)
    assert(isequal(size(Yh), size(Y)));
    if size(Yh,1) == 1
        Yh = Yh'; Y = Y';
    end
    top = Yh - Y;
    bot = Y - mean(Y);
    v = 1 - (top'*top)/(bot'*bot);
end
