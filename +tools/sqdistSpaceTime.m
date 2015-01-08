function D = sqdistSpaceTime(xy, ns, nt)
% make combined spatial/temporal squared distance matrix, D
    Ds = repmat(tools.sqdistSpace(xy), nt, nt);
    Dt = tools.sqdistTime(nt, ns);
    D = nan(ns*nt, ns*nt, 2);
    D(:,:,1) = Ds;
    D(:,:,2) = Dt;
end
