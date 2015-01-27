function [wMAP, b, hyper] = fitMinNegLogEvi(X, Y, hyper0, opts)

    LOWER_BOUND_DELTA_TEMPORAL = 0.12;
    ndeltas = size(opts.D, 3);
    
    fitIntercept = opts.fitIntercept;
    opts.fitIntercept = false;
    [X, Y, X_mean, Y_mean] = reg.centerData(X, Y, fitIntercept);    
%     w0 = bernASD_MAP(X, Y, hyper0, opts);
    
    if opts.isLog
        hyper0 = log(hyper0);
        lbs = [-3, -5*ones(1,ndeltas)];
        ubs = [3, 10*ones(1,ndeltas)];
    else
        lbs = [-20, LOWER_BOUND_DELTA_TEMPORAL*ones(1,ndeltas)];
        ubs = [20, 1e5*ones(1,ndeltas)];
    end
    objopts = optimset('display', 'off', 'gradobj', 'off', ...
        'largescale', 'off', 'algorithm', 'Active-Set');
    get_hyper = @(hy, isLog) ~isLog*hy + isLog*exp(hy);
    obj = @(hy) negLogPost(X, Y, get_hyper(hy, opts.isLog), opts);
    hyper = fmincon(obj, hyper0, [], [], [], [], lbs, ubs, [], objopts);
    hyper = get_hyper(hyper, opts.isLog);

    wMAP = asd.objfcn.bernASD_MAP(X, Y, hyper, opts);
    b = reg.setIntercept(X_mean, Y_mean, wMAP, fitIntercept);

end

function val = negLogPost(X, Y, hyper0, opts)
    [~, ~, ~, val] = asd.objfcn.bernASD_MAP(X, Y, hyper0, opts);
end
