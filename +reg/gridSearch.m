function [XBest, BestF, niters] = gridSearch(fcn, lbs, ubs, ns, minDeltaX, tol, maxiter)
% Function performs multivariate optimization using the
% grid search.
%
% Input
%
% fcn - name of the optimized function
% lbs - array of lower values
% ubs - array of higher values
% ns - array of number of divisions along each dimension
% minDeltaX - array of minimum search values for each variable
% tol - tolerance for difference in successive function values
% maxiter - maximum number of iterations
%
% Output
%
% XBest - array of optimized variables
% BestF - function value at optimum
% niters - number of iterations
%

if nargin < 7
    maxiter = 1e4;
end
if nargin < 6
    tol = 1e-7;
end
if nargin < 5
    minDeltaX = 1e-5*ones(1, numel(lbs));
end

N = numel(lbs);
Xcenter = (ubs + lbs) / 2;
XBest = Xcenter;
DeltaX = (ubs - lbs) ./ ns;
BestF = feval(fcn, XBest);
if BestF >= 0
  LastBestF = BestF + 100;
else
  LastBestF = 100 - BestF;
end

niters = 0;
nzooms = 0;
X = lbs; % initial search value
while any(DeltaX > minDeltaX) && (abs(BestF - LastBestF) > tol) && (niters <= maxiter)

  bGoOn2 = 1;

  while bGoOn2 > 0

    niters = niters + 1;

    F = feval(fcn, X);
    if F < BestF
      LastBestF = BestF;
      BestF = F;
      XBest = X;
    end

    for ii = 1:N
      if X(ii) >= ubs(ii)
        if ii < N
          X(ii) = lbs(ii);
        else
          bGoOn2 = 0;
          break
        end
      else
        X(ii) = X(ii) + DeltaX(ii);
        break
      end
    end

  end

  XCenter = XBest;
  DeltaX = DeltaX ./ ns;
  lbs = XCenter - DeltaX .* ns / 2;
  ubs = XCenter + DeltaX .* ns / 2;
  X = lbs; % set initial X
  nzooms = nzooms + 1;
end
nzooms
