function X = ifNecessaryAddDC(X, w)
    if size(X,2) == size(w,1) - 1
        X = [X ones(size(X,1),1)];
    end
end
