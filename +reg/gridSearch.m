function [XBest,BestF,Iters] = gridSearch(XLo, XHi, NumDiv, MinDeltaX, Eps_Fx, MaxIter, myFx)
% Function performs multivariate optimization using the
% grid search.
%
% Input
%
% XLo - array of lower values
% XHi - array of higher values
% NumDiv - array of number of divisions along each dimension
% MinDeltaX - array of minimum search values for each variable
% Eps_Fx - tolerance for difference in successive function values
% MaxIter - maximum number of iterations
% myFx - name of the optimized function
%
% Output
%
% XBest - array of optimized variables
% BestF - function value at optimum
% Iters - number of iterations
%
N = numel(XLo);
Xcenter = (XHi + XLo) / 2;
XBest = Xcenter;
DeltaX = (XHi - XLo) ./ NumDiv;
BestF = feval(myFx, XBest);
if BestF >= 0
  LastBestF = BestF + 100;
else
  LastBestF = 100 - BestF;
end
X = XLo; % initial search value

Iters = 0;

while any(DeltaX > MinDeltaX) && (abs(BestF - LastBestF) > Eps_Fx) && (Iters <= MaxIter)

  bGoOn2 = 1;

  while bGoOn2 > 0

    Iters = Iters + 1;

    F = feval(myFx, X);
    if F < BestF
      LastBestF = BestF;
      BestF = F;
      XBest = X;
    end

    for ii = 1:N
      if X(ii) >= XHi(ii)
        if ii < N
          X(ii) = XLo(ii);
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
  DeltaX = DeltaX ./ NumDiv;
  XLo = XCenter - DeltaX .* NumDiv / 2;
  XHi = XCenter + DeltaX .* NumDiv / 2;
  X = XLo; % set initial X
end
