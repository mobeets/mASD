cd ..
fname = 'tests/testDataLinear.mat';
data = load(fname);
M = asd.linearASDStruct(data.D);
mlFcn = @(~) ml.fitopts('gauss');
isLinReg = true;
cd tests
updateFit(fname, data, M, mlFcn, isLinReg);
