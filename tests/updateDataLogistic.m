fname = '+test/testDataLogistic.mat';
data = load(fname);
M = asd.logisticASDStruct(data.D);
mlFcn = @(~) ml.fitopts('bern');
isLinReg = false;
updateFit(fname, data, M, mlFcn, isLinReg);
