function fig = plotKernel(xy, wf, vmax, figLbl, sz, figSz, clrFcn)
% plots an nw-by-nt spatiotemporal kernel
%   creates nt subplots each with nw weights
% 
% xy - spatial coords or wf
% wf - weights to plot
% vmax - normalizer for wf (default is maximum value in wf)
% sz - size of markers
% figSz - size of figure
% figLbl - prefix for title of each subplot
% clrFcn - color function handle of form color = f(wf(i,j)) for any i,j
% 
    if nargin < 7 || isnan(clrFcn)
        clrs = defaultColorScheme();
        clrFcn = colorFcn(clrs{:});
    end
    if nargin < 6 || isnan(figSz)
        figSz = 1.0;
    end
    if nargin < 5 || isnan(sz)
        sz = 50;
    end
    if nargin < 4 || any(isnan(figLbl))
        figLbl = '';
    end
    if nargin < 3 || isnan(vmax)
        vmax = max(abs(wf(:)));
    end
    mrg = 1.0;
    titleFontSize = 14;
    
    [nw, nt] = size(wf);
    fig = figure;
    ha = plot.tight_subplot(1, nt, [.01 .03], [.1 .01], [.01 .01]);

    for ii = 1:nt
        axes(ha(ii)); hold on;
        for jj = 1:nw
            clr = clrFcn(wf(jj,ii)/vmax);
            plot(xy(jj,1), xy(jj,2), 'Marker', '.', 'MarkerSize', sz, 'Color', clr, 'LineStyle', 'none');
        end
        subplotFormat();
        xlim([min(xy(:,1))-mrg, max(xy(:,1))+mrg]);
        ylim([min(xy(:,2))-mrg, max(xy(:,2))+mrg]);
        if ii == round(nt/2)
            ht = title(figLbl);
            set(ht, 'FontSize', titleFontSize);
        end
        xlabel(['t=', num2str(ii)]); % acts like a subplot title
    end
    plot.suplabel(figLbl, 't'); 
    
    pos = get(gcf,'Position');
    pos(3:4) = figSz*[10e2 2e2];
    set(gcf, 'Position', pos);
    set(gcf,'color','w')
end

function subplotFormat()
    axis square;
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    set(gca, 'LineWidth', 1)
    box on;
end

%%
function clrs = defaultColorScheme()
    clrPos = [0.3, 0.3, 0.9];
    clrNeg = [0.9, 0.3, 0.3];
    clrMid = [0.95, 0.95, 0.95];
    clrs = {clrNeg, clrMid, clrPos};
end

function v = getColor2(x, clrStart, clrEnd)
    v = clrStart + x*(clrEnd - clrStart);
end

function v = getColor(x, clrNeg, clrMid, clrPos)
    if x >= 0
        v = getColor2(x, clrMid, clrPos);
    else
        v = getColor2(-x, clrMid, clrNeg);
    end 
end

function f = colorFcn(clrNeg, clrMid, clrPos)
    f = @(x) getColor(x, clrNeg, clrMid, clrPos);
end
