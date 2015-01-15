function [L,dL,ddL] = neglogli_bernoulliGLM(wts,X,Y)
% [L,dL,ddL] = neglogli_bernoulliGLM(wts,X,Y)
%
% Compute negative log-likelihood of data under logistic regression model,
% plus gradient and Hessian
%
% Inputs:
% wts [m x 1] - regression weights
%   X [N x m] - regressors
%   Y [N x 1] - output (binary vector of 1s and 0s).

if size(wts,1) == size(X,2)+1
    % wts includes DC term
    X = [X ones(size(X,1),1)];
end
xproj = X*wts;

if nargout <= 1
    L = -Y'*xproj + sum(softrect(xproj)); % neg log-likelihood

elseif nargout == 2
    [f,df] = softrect(xproj); % evaluate log-normalizer
    L = -Y'*xproj + sum(f); % neg log-likelihood
    dL = X'*(df-Y);         % gradient

elseif nargout == 3
    [f,df,ddf] = softrect(xproj); % evaluate log-normalizer
    L = -Y'*xproj + sum(f); % neg log-likelihood
    dL = X'*(df-Y);         % gradient
    ddL = X'*bsxfun(@times,X,ddf); % Hessian
end
end

% -------------------------------------------------------------
% ----- SoftRect Function (log-normalizer) --------------------
% -------------------------------------------------------------

function [f,df,ddf] = softrect(x)
%  [f,df,ddf] = softrect(x);
%
%  Computes: f(x) = log(1+exp(x))
%  and first and second derivatives

f = log(1+exp(x));

if nargout > 1
    df = exp(x)./(1+exp(x));
end
if nargout > 2
    ddf = exp(x)./(1+exp(x)).^2;
end

% Check for small values
if any(x(:)<-20)
    iix = (x(:)<-20);
    f(iix) = exp(x(iix));
    df(iix) = f(iix);
    ddf(iix) = f(iix);
end

% Check for large values
if any(x(:)>500)
    iix = (x(:)>500);
    f(iix) = x(iix);
    df(iix) = 1;
    ddf(iix) = 0;
end
end
