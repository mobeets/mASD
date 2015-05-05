function wML = calcPoissML(X, R, ~)
    obj = @(w) tools.neglogli_poissGLM(w, X, R, @tools.expfun);
    objopts = optimset('display', 'off', 'gradobj', 'on', ...
            'largescale', 'off', 'algorithm', 'Active-Set');
    w0 = (X'*X)\(X'*R);
    wML = fminunc(obj, w0*0, objopts);
end
