function plotKernel(xy, wf, vmax, sz, figsz)
    if nargin < 5
        figsz = 1.0;
    end
    if nargin < 4
        sz = 50;
    end
    if nargin < 3
        vmax = max(abs(wf(:)));
    end
    mrg = 1.0;
    
    [nt, nx] = size(wf);
    [clrMid, clrNeg, clrPos] = colorScheme();
    figure;
    ha = tight_subplot(1, nt, [.01 .03],[.1 .01],[.01 .01]);

    for ii = 1:nt
        axes(ha(ii)); hold on;
        clr = getColor((wf(ii,:)/vmax), clrNeg, clrMid, clrPos);
        for jj = 1:nx
%             disp([ii, jj, xy(jj,1), xy(jj,2), clr(jj,:)]);
            plot(xy(jj,1), xy(jj,2), 'Marker', '.', 'MarkerSize', sz, 'Color', clr(jj,:), 'LineStyle', 'none');
        end
        subplotFormat();
        xlim([min(xy(:,1))-mrg, max(xy(:,1))+mrg]);
        ylim([min(xy(:,2))-mrg, max(xy(:,2))+mrg]);
        title(['t=', num2str(ii)]);
    end
    
    pos = get(gcf,'Position');
    pos(3:4) = figsz*[10e2 2e2];
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
function [clrMid, clrNeg, clrPos] = colorScheme()
    clrPos = [0.3, 0.3, 0.9];
    clrNeg = [0.9, 0.3, 0.3];
    clrMid = [0.95, 0.95, 0.95];
end

function v = getColor2(x, clrStart, clrEnd)
    v = clrStart + x*(clrEnd - clrStart);
end

function v = getColor(xs, clrNeg, clrMid, clrPos)
    v = nan(numel(xs), 3);
    for ii = 1:numel(xs)
        if xs(ii) >= 0.0
            v(ii,:) = getColor2(xs(ii), clrMid, clrPos);
        else
            v(ii,:) = getColor2(-xs(ii), clrMid, clrNeg);
        end
    end
end
