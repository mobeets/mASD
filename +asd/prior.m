function v = prior(ro, Ds, deltas)
% v = prior(ro, Ds, deltas)
% 
% ro - float
% Ds - (q x q x nd) - squared distance matrix in some stimulus dimension
% deltas - (nd x 1) - float, the weighting of D
% 
    vs = 0.0;
    for ii = 1:numel(deltas)
        vs = vs + Ds(:,:,ii)/(deltas(ii)^2);
    end
    v = exp(-ro-0.5*vs);
end
