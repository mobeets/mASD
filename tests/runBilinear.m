function mu = runBilinear(doReshape)
    rng(10431);
    ny = 1000; ns = 10; nt = 4;
    X = rand(ny, ns, nt);
    Y = rand(ny, 1);
    hyper = [1.0 0.2865 0.1];
    Xxy = rand(ns, 2);
    D = asd.sqdist.space(Xxy);

    sFcn = @asd.gauss.calcMAP;
    sFcnOpts = {hyper, D};
    tFcn = @ml.calcGaussML;
    tFcnOpts = {};
    opts.maxiters = 100;
    opts.tol = 1e-5;
    opts.wt0 = ones(size(X,3),1);
    
    fcns = struct('sFcn', sFcn, 'sFcnOpts', {sFcnOpts}, ...
        'tFcn', tFcn, 'tFcnOpts', {tFcnOpts});
    
    if doReshape
        X = reshape(X, ny, ns*nt);
        opts.shape = {ns, nt};
        mu = reg.calcBilinear(X, Y, fcns, opts);
    else
        mu = reg.calcBilinear(X, Y, fcns, opts);
    end
end
