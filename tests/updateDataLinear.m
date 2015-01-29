cd ..
fname = 'tests/testDataLinear.mat';
data = load(fname);
M = asd.linearASDStruct(data.D);
mlFcn = @(~) ml.fitopts('gauss');
isLinReg = true;
cd tests
updateFits(fname, data, M, mlFcn, isLinReg);
