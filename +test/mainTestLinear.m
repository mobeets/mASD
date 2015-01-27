data = load('+test/testDataLinear.mat');
M = asd.linearASDStruct(data.D);
mlFcn = @(~) ml.fitopts('gauss');
isLinReg = true;
test.testFit(data, M, mlFcn, isLinReg);
