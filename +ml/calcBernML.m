function wML = calcBernML(X, R, ~)
    obj = @(w) tools.neglogli_bernoulliGLM(w, X, R);
    objopts = optimset('display', 'off', 'gradobj', 'on', ...
            'largescale', 'off', 'algorithm', 'Active-Set');
    w0 = (X'*X)\(X'*R);
    wML = fminunc(obj, w0, objopts);
end
