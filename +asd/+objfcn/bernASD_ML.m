function wML = bernASD_ML(X, Y, hyper, opts)
% hyper - not used
% opts - not used
% 

w0 = (X'*X)\(X'*Y); % stupid starting point
objfcn = @(w) neglogli_bernoulliGLM(w, X, Y);
wML = fminunc(objfcn, w0);

end
