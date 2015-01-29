cd ..
fname = 'tests/testDataLogistic.mat';
data = load(fname);
M = asd.logisticASDStruct(data.D);
mlFcn = @(~) ml.fitopts('bern');
isLinReg = false;
cd tests
updateFit(fname, data, M, mlFcn, isLinReg);

