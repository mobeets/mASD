function v = time(nt, ns)
% returns squared distance matrix with size [nt*ns, nt*ns]
    d = repmat(1:nt, ns, 1);
    xy = [d(:) zeros(numel(d), 1)];
    v = asd.sqdist.space(xy);
end
