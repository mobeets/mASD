%% load
data = loadData('data/XY.mat');
cell_names = [14 15 16 19 20 21 23 24 25 27];
% i.e. column i of data.Y ~> cell # cell_names(i)

%% params

nfolds = 7;
fold_for_plots = 1;

figdir = 'figs';
datdir = 'data';
dat_fnfcn = @(tag) fullfile(datdir, [tag '.mat']);
fig_fnfcn = @(tag, ext) fullfile(figdir, [tag '.' ext]);
fig_svfcn = @(fig, tag, ext) hgexport(fig, fig_fnfcn(tag, ext), hgexport('factorystyle'), 'Format', ext);

%% run on all cells

isLinReg = true;
llstr = 'poiss';
hypergrid = asd.makeHyperGrid(nan, nan, nan, data.ndeltas, false, isLinReg);
M = asd.linearASDStruct(data.D, llstr);

% cell_inds = 2;
cell_inds = 1:size(data.Y_all, 2);

ncells = numel(cell_inds);
for nn = 1:ncells
    cell_ind = cell_inds(nn);
    data.Y = data.Y_all(:,cell_ind); % choose cell for analysis    
    [ASD, ML] = runASDandML(data, M, hypergrid, nfolds, fold_for_plots);
    lbl = ['cell_' num2str(cell_ind)];
    save(dat_fnfcn(lbl), 'ASD', 'ML');
    fig_svfcn(ML.fig, [lbl '-ML'], 'png');
    fig_svfcn(ASD.fig, [lbl '-ASD_' llstr], 'png');
end

%% run on decision

isLinReg = false;
hypergrid = asd.makeHyperGrid(nan, nan, nan, data.ndeltas, false, isLinReg);
M = asd.logisticASDStruct(data.D);
data.Y = data.R;
[ASD, ML] = runASDandML(data, M, hypergrid, nfolds, fold_for_plots);

save(dat_fnfcn('decision'), 'ASD', 'ML');
fig_svfcn(ASD.fig, 'decision-ASD', 'png');
fig_svfcn(ML.fig, 'decision-ML', 'png');
