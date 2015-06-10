function fcn = getPredictionFcn(isLinReg)
    if isLinReg
        fcn = @(X, w) tools.ifNecessaryAddDC(X,w)*w;
    else
        fcn = @(X, w) tools.logistic(...
            tools.ifNecessaryAddDC(X,w)*w);
    end
end
