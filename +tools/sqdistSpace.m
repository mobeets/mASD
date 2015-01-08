function v = sqdistSpace(xy)
% xy is size [ns, 2]
% returns squared distance matrix, size [ns, ns]
    v = squareform(pdist(xy, 'euclidean')).^2;
end
