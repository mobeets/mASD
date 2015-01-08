function grid = cartesianProduct(I)
% returns cartesian product (a matrix) of all possible values in I
% 
% I [cell array] - values of various parameters
% 
    ndim = numel(I);
    [I{1:ndim}] = ndgrid(I{:});
    ndimy = numel(I{1}(:));
    grid = nan(ndimy, ndim);
    for ii = 1:ndim
        grid(:,ii) = I{ii}(:);
    end
end
