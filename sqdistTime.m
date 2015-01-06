function v = sqdistTime(nt, ns)
% returns squared distance matrix with size [nt*ns, nt*ns]
    xy = [1:nt; zeros(1,nt)]';
    D = sqdist(xy);
    v = repmat(D, ns, ns);
end
