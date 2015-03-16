cd ..
fname = 'testDataLogistic.mat';
data = load(fullfile('tests', fname));
[~, data.evalinds] = reg.trainAndTest(data.X, data.Y, 0.5);
M = asd.logisticASDStruct(data.D);
mlFcn = @(~) ml.fitopts('bern');
isLinReg = false;
cd tests
updateFits(fname, data, M, mlFcn, isLinReg);
