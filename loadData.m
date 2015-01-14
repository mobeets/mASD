function [X, Y, R, D, Xxy, nt, ns] = loadData(infile)
    load(infile, 'X', 'Y', 'R', 'Xxy');    
    [ny, nt, ns] = size(X);
    X = permute(X, [1 3 2]);
    X = reshape(X, ny, nt*ns);
    D = asd.sqdistSpaceTime(Xxy, ns, nt);
end
