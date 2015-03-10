function mu = runBilinear()
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

    mu = reg.calcBilinear(X, Y, sFcn, sFcnOpts, tFcn, tFcnOpts, opts);
end
