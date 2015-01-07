function v = setIntercept(X_mean, Y_mean, w, fitIntercept)
    if fitIntercept
        v = Y_mean - X_mean*w;
    else
        v = 0.0;
    end
end
