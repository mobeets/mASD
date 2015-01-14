function D = sqdistSpaceTime(xy, ns, nt)
% make combined spatial/temporal squared distance matrix, D
    Ds = repmat(asd.sqdistSpace(xy), nt, nt);
    Dt = asd.sqdistTime(nt, ns);
    D = nan(ns*nt, ns*nt, 2);
    D(:,:,1) = Ds;
    D(:,:,2) = Dt;
end
