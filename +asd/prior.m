function v = prior(ro, Ds, deltas)
% 
% ro - float
% Ds, deltas - vectors of:
%     D - (q x q) squared distance matrix in some stimulus dimension
%     delta - float, the weighting of D
% 
    vs = 0.0;
    for ii = 1:numel(deltas)
        vs = vs + Ds(:,:,ii)/(deltas(ii)^2);
    end
    v = exp(-ro-0.5*vs);
end
