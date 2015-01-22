%% load
data = loadData('data/XY.mat');
cell_names = [14 15 16 19 20 21 23 24 25 27];
% i.e. column i of data.Y ~> cell # cell_names(i)

%% params

nfolds = 7;
fold_for_plots = 1;
[~,~,~,~,foldinds] = reg.trainAndTestKFolds(data.X, data.R, nfolds);

figdir = 'data/figs';
datdir = 'data/fits';
dat_fnfcn = @(tag) fullfile(datdir, [tag '.mat']);
fig_fnfcn = @(tag, ext) fullfile(figdir, [tag '.' ext]);
fig_svfcn = @(fig, tag, ext) hgexport(fig, fig_fnfcn(tag, ext), hgexport('factorystyle'), 'Format', ext);

%% run on all cells

isLinReg = true;
llstr = 'gauss';
hypergrid = asd.makeHyperGrid(nan, nan, 3, data.ndeltas, false, isLinReg);
M = asd.linearASDStruct(data.D, llstr);

% cell_inds = 2;
cell_inds = 1:size(data.Y_all, 2);

ncells = numel(cell_inds);
for nn = 1:ncells
    cell_ind = cell_inds(nn);
    data.Y = data.Y_all(:,cell_ind); % choose cell for analysis
%     fits = reg.runASDandML_grid(data, M, hypergrid, foldinds, fold_for_plots);
    fits.ASD = reg.scoreHypergrid(data, hypergrid, M.mapFcn, M.mapFcnOpts, ...
        M.rsqFcn, {}, foldinds, ['ASD-' llstr], fold_for_plots);
    fits.ML = reg.scoreHypergrid(data, hypergrid, M.mlFcn, {}, ...
        M.rsqFcn, {}, foldinds, 'ML', 1);
    fits.isLinReg = isLinReg;
    lbl = ['cell_' num2str(cell_ind)];
    updateStruct(dat_fnfcn(lbl), fits);
    fig_svfcn(fits.ML.fig, [lbl '-ML'], 'png');
    fig_svfcn(fits.ASD.fig, [lbl '-ASD_' llstr], 'png');
end

%% run on decision

isLinReg = false;
hypergrid = asd.makeHyperGrid(nan, nan, 7, data.ndeltas, false, isLinReg);
M = asd.logisticASDStruct(data.D);
data.Y = data.R;
fits.ASD = reg.scoreHypergrid(data, hypergrid, M.mapFcn, M.mapFcnOpts, ...
    M.rsqFcn, {}, foldinds, 'ASD', fold_for_plots);
fits.ML = reg.scoreHypergrid(data, hypergrid, M.mlFcn, {}, ...
    M.rsqFcn, {}, foldinds, 'ML', 1);
fits.isLinReg = isLinReg;

updateStruct(dat_fnfcn('decision'), fits);
fig_svfcn(fits.ASD.fig, 'decision-ASD', 'png');
fig_svfcn(fits.ML.fig, 'decision-ML', 'png');

%% run on decision -- grid search

isLinReg = false;
M = asd.logisticASDStruct(data.D);
data.Y = data.R;
lbs = [-3, -2, -5]; ubs = [3, 10, 10]; ns = [3, 3, 3]; isLog = true;
fits.ASD = reg.scoreGridSearch(data, lbs, ubs, ns, M.mapFcn, ...
    M.mapFcnOpts, M.rsqFcn, {}, foldinds, fold_for_plots, 'ASD', isLog);
fits.isLinReg = isLinReg;

updateStruct(dat_fnfcn('decision_srch'), fits);
fig_svfcn(fits.ASD.fig, 'decision_srch-ASD', 'png');
