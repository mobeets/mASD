function [X, Y, X_mean, Y_mean] = centerData(X, Y, fitIntercept)
    if fitIntercept
        X_mean = zeros(1, size(X,2));
        X_mean = mean(X, 1);
        X = X - repmat(X_mean, size(X, 1), 1);
        
        Y_mean = mean(Y, 1);
        Y = Y - Y_mean;
    else
        X_mean = zeros(1, size(X,2));
        Y_mean = 0.0;
    end
end
