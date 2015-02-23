function val = pseudoRsq(ll, llSat, llNull)
    if numel(ll) > 1 || numel(llSat) > 1 || numel(llNull) > 1
        x=1;
    end
    if llSat < llNull
        x=1;
    end
    if llSat < ll
        x=1;
    end
    assert(llSat >= llNull);
    assert(llSat >= ll);
    val = 1 - ((llSat - ll)/(llSat - llNull));
end
