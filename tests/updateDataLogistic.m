cd ..
fname = 'testDataLogistic.mat';
data = load(fullfile('tests', fname));
M = asd.logisticASDStruct(data.D);
mlFcn = @(~) ml.fitopts('bern');
isLinReg = false;
cd tests
updateFits(fname, data, M, mlFcn, isLinReg);
