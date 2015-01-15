function [L,dL,H] = neglogli_poissGLM(wts,x,y,fnlin)
% [L,dL,ddL] = neglogli_poissGLM(wts,X,Y)
%
% Compute negative log-likelihood of data under Poisson regression model,
% plus gradient and Hessian
%
% INPUT:
% wts [m x 1] - regression weights
%   X [N x m] - regressors
%   Y [N x 1] - output (binary vector of 1s and 0s).
%       fnlin - func handle for nonlinearity (must return f, df and ddf)
%
% OUTPUT:
%   L [1 x 1] - negative log-likelihood
%  dL [m x 1] - gradient
% ddL [m x m] - Hessian

m = numel(wts);
xproj = x*wts;

switch nargout
    case 1
	f = fnlin(xproj);
	L = -y'*log(f) + sum(f); % neg log-likelihood
    L = full(L);
    case 2
	[f,df] = fnlin(xproj); % evaluate nonlinearity
	
	L = -y'*log(f) + sum(f); % neg log-likelihood
    L = full(L);
	%L(1 + (1:m)) = (1 - y./f)' * df * wts;
	dL = x'*((1 - y./f) .* df);% K: fixed the gradient
    dL = full(dL);
    case 3
	[f,df,ddf] = fnlin(xproj); % evaluate nonlinearity

	L = -y'*log(f) + sum(f); % neg log-likelihood
	yf = y./f;
	%L(1 + (1:m)) = (1 - yf)' * df * wts;
	dL = x'*((1 - yf) .* df);
	%H = (yf' * (df.^2 ./ f - ddf) + sum(ddf)) * (wts*wts');
    H = bsxfun(@times,ddf.*(1-yf)+df.*(y./f.^2.*df) ,x)'*x; %K: fixed the Hessian
    L = full(L);
    dL = full(dL);
    H = full(H);
% 	L(m+2:end) = H(:);
end

end % neglogli_poissGLM_sub
