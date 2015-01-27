function hyper = optMinNegLogEvi(X, Y, hyper0, D, isLog)

    LOWER_BOUND_DELTA_TEMPORAL = 0.12;
    ndeltas = size(D, 3);

    if isLog
        hyper0 = log(hyper0);
        lbs = [-3, -5*ones(1,ndeltas)];
        ubs = [3, 10*ones(1,ndeltas)];
    else
        lbs = [-20, LOWER_BOUND_DELTA_TEMPORAL*ones(1,ndeltas)];
        ubs = [20, 1e5*ones(1,ndeltas)];
    end
    objopts = optimset('display', 'off', 'gradobj', 'off', ...
        'largescale', 'off', 'algorithm', 'Active-Set');
    get_hyper = @(hy, is_log) ~is_log*hy + is_log*exp(hy);
    obj = @(hy) negLogPost(X, Y, get_hyper(hy, isLog), D);
    hyper = fmincon(obj, hyper0, [], [], [], [], lbs, ubs, [], objopts);
    hyper = get_hyper(hyper, isLog);

end

function val = negLogPost(X, Y, hyper0, D)
    % see: calcMAP for how to calculate log posterior
    val = nan;
%     [~, ~, ~, val] = asd.objfcn.bernASD_MAP(X, Y, hyper0, D);
end
