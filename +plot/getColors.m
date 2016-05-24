function clrs = getColors(C, loadCmap, cmin, cmax)
    if nargin < 2
        loadCmap = true;        
    end
    if nargin < 3 || isnan(cmin)
        % diverging colorscheme, so take abs        
        cmax = max(abs(C));
        cmin = -cmax;
    end
    if nargin < 4 || isnan(cmax)
        cmax = -cmin;
    end
    if loadCmap
        colormap(cbrewer('div', 'RdBu', 201, 'pchip'));
    end
    cmap = colormap;
    m = size(cmap,1);
    if cmax == cmin
        cind = round(m/2)*ones(size(C,1),1);
    else
        cind = fix((C-cmin)/(cmax-cmin)*m)+1;
    end
    cind(cind<1) = 1;
    cind(cind>m) = m;
    clrs = cmap(cind,:);
%     caxis([cmin cmax]);
end
