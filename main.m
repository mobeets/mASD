%% params

nfolds = 7;
fold_for_plots = 1;

figdir = 'figs';
datdir = 'data';
figfcn = @(tag1, tag2, ext) fullfile(figdir, [tag1 '-' tag2 '.' ext]);
datfcn = @(tag1) fullfile(datdir, [tag1 '.mat']);

%% load

data = loadData('data/XY.mat');

%% run on all cells

isLinReg = true;
llstr = 'poiss';
hypergrid = asd.makeHyperGrid(nan, nan, nan, data.ndeltas, false, isLinReg);
M = linearASDStruct(data.D, llstr);

ncells = size(data.Y_all, 2);
% ncells = 1;
for nn = 1:ncells
    data.Y = data.Y_all(:,nn); % choose nn-th cell for analysis    
    [ASD, ML] = runASDandML(data, M, hypergrid, nfolds, fold_for_plots);
    lbl = ['cell_' num2str(nn)];
    save(datfcn(lbl), 'ASD', 'ML');
    print(ASD.fig, '-dpng', figfcn([lbl '_' llstr], 'ASD', 'png'));
    print(ML.fig, '-dpng', figfcn(lbl, 'ML', 'png'));
end

%% run on decision

isLinReg = false;
hypergrid = asd.makeHyperGrid(nan, nan, nan, data.ndeltas, false, isLinReg);
M = logisticASDStruct(data.D);
data.Y = data.R;
[ASD, ML] = runASDandML(data, M, hypergrid, nfolds, fold_for_plots);

save(datfcn('decision'), 'ASD', 'ML');
print(ASD.fig, '-dpng', figfcn('decision', 'ASD', 'png'));
print(ML.fig, '-dpng', figfcn('decision', 'ML', 'png'));
