function D = spaceTime(xy, ns, nt)
% make combined spatial/temporal squared distance matrix, D
    Ds = repmat(asd.sqdist.space(xy), nt, nt);
    Dt = asd.sqdist.time(nt, ns);
    D = nan(ns*nt, ns*nt, 2);
    D(:,:,1) = Ds;
    D(:,:,2) = Dt;
end
