function [L,dL,H] = neglogli_poissGLM(wts,x,y,fnlin)
% [L,dL,ddL] = neglogli_poissGLM(wts,x,y,fnlin)
%
% Compute negative log-likelihood of data under Poisson regression model,
% plus gradient and Hessian
%
% INPUT:
% wts [m x 1] - regression weights
%   x [N x m] - regressors
%   y [N x 1] - output (binary vector of 1s and 0s).
%       fnlin - func handle for nonlinearity (must return f, df and ddf)
%
% OUTPUT:
%   L [1 x 1] - negative log-likelihood
%  dL [m x 1] - gradient
% ddL [m x m] - Hessian

xproj = x*wts;

% if any are -Inf or 0, log() will blow up
xproj((xproj < 0) & isinf(xproj)) = -1e9;
xproj(xproj == 0) = 1e-9;

Lf = @(y, f) -y'*log(f) + sum(f); % neg log-likelihood
dLf = @(x, y, f, df) x'*((1 - y./f) .* df); % gradient
Hf = @(x, y, f, df, ddf) bsxfun(@times, ddf.*(1-(y./f)) + ...
    df.*(y./f.^2.*df), x)'*x;

switch nargout
    case 1
        f = fnlin(xproj);
        L = full(Lf(y, f));
    case 2
        [f,df] = fnlin(xproj); % evaluate nonlinearity
        L = full(Lf(y, f));
        dL = full(dLf(x, y, f, df));
    case 3
        [f,df,ddf] = fnlin(xproj); % evaluate nonlinearity
        L = full(Lf(y, f));
        dL = full(dLf(x, y, f, df));
%         H = bsxfun(@times,ddf.*(1-(y./f))+df.*(y./f.^2.*df) ,x)'*x; %K: fixed the Hessian
        H = full(Hf(x, y, f, df, ddf));
end

end % neglogli_poissGLM_sub
