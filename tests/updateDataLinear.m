fname = '+test/testDataLinear.mat';
data = load(fname);
M = asd.linearASDStruct(data.D);
mlFcn = @(~) ml.fitopts('gauss');
isLinReg = true;
updateFit(fname, data, M, mlFcn, isLinReg);
