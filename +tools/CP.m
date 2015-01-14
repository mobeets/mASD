function val = CP(Y0, Y1)
    v0 = min([Y0; Y1]);
    v1 = max([Y0; Y1]);
    vs = v0:v1;
    
    ps = nan(numel(vs),2);
    for ii = 1:numel(vs)
        v = vs(ii);
        fp = sum(Y0 > v)/numel(Y0);
        tn = sum(Y0 <= v)/numel(Y0);
        tp = sum(Y1 > v)/numel(Y1);
        fn = sum(Y1 <= v)/numel(Y1);
        ps(ii,:) = [fp, tp];
    end
    figure; scatter(ps(:,1), ps(:,2));
end
