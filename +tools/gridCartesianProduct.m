function grid = gridCartesianProduct(lbs, ubs, ns, fs)
% generates a cartesian product for variables
%   where each variable's range of values is given by f(lb, ub, n)
% 
% lbs - set of lower bounds
% ubs - set of upper bounds
% ns - # of values to be interpolated
% fs - interpolation functions (default: linear)
%
% returns matrix of all combinations of interpolated values
% 
    ndim = numel(lbs);
    if nargin < 4
        lf = @(lb, ub, n) linspace(lb, ub, n);
        fs = cell(1, ndim);
        for ii = 1:ndim
            fs{ii} = lf;
        end
    end
    
    I = cell(ndim, 1);
    for di = 1:ndim
        I{di} = fs{di}(lbs(di), ubs(di), ns(di));
    end
    grid = tools.cartesianProduct(I);
end
