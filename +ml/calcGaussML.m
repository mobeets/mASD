function wML = calcGaussML(X, Y, ~)
    wML = (X'*X)\(X'*Y);
end
