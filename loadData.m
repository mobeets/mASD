function data = loadData(infile)
    load(infile, 'X', 'Y', 'R', 'Xxy');    
    [ny, nt, ns] = size(X);
    X = permute(X, [1 3 2]);
    X = reshape(X, ny, nt*ns);
    D = asd.sqdistSpaceTime(Xxy, ns, nt);
%     Xxy = Xxy; % todo: flip y-axis
    
    data.X = X;
    data.Y_all = Y;
    data.R = R;
    data.D = D;
    data.ndeltas = size(D, 3);
    data.Xxy = Xxy;
    data.ns = ns;
    data.nt = nt;
end
