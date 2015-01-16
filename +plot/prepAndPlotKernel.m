function fig = prepAndPlotKernel(Xxy, wf, ns, nt, ifold, lbl, sc)
% plots the spatiotemporal kernel
    wf = wf(1:end-1);
    wf = reshape(wf, ns, nt);
    scstr = sprintf('%.2f', sc);
    title = [lbl ' f', num2str(ifold) ' sc=' num2str(scstr)];
    fig = plot.plotKernel(Xxy, wf, nan, title);
end
