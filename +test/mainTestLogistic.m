data = load('+test/testDataLogistic.mat');
M = asd.logisticASDStruct(data.D);
mlFcn = @(~) ml.fitopts('bern');
isLinReg = false;
test.testFit(data, M, mlFcn, isLinReg);
