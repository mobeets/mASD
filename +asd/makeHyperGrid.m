function hypergrid = makeHyperGrid(lbs, ubs, ns, ndeltas, isLog, isLinReg)
% n.b. lbs and ubs are given by default in log space
% if isGauss is false, drops the ssq hyperparam
    if nargin < 1 || any(isnan(lbs))
        lbs = [-3, -2, -5];
    end
    if nargin < 2 || any(isnan(ubs))
        ubs = [3, 10, 10];
    end
    if nargin < 3 || any(isnan(ns)) || numel(ns) == 1
        if numel(ns) == 1
            val = ns;
        else
            val = 5;
        end
        ns = val*ones(1, 3);
    end
    if nargin < 4 || isnan(ndeltas)
        ndeltas = 1;
    end
    if nargin < 5 || isnan(isLog)
        isLog = false;
    end
    if nargin < 6 || isnan(isLinReg)
        isLinReg = true;
    end
    assert(ndeltas >= 1);
    
    if ndeltas > 1
        lbs = [lbs(1) lbs(2) lbs(3)*ones(1, ndeltas)];
        ubs = [ubs(1) ubs(2) ubs(3)*ones(1, ndeltas)];
        ns = [ns(1) ns(2) ns(3)*ones(1, ndeltas)];
    end
    if ~isLinReg
        lbs = lbs([1, 3:end]);
        ubs = ubs([1, 3:end]);
        ns = ns([1, 3:end]);
    end
    
    hypergrid = tools.boundedCartesianProduct(lbs, ubs, ns);

    if ~isLog
        hypergrid = exp(hypergrid);
    end
end
