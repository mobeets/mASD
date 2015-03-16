cd ..
fname = 'testDataLinear.mat';
data = load(fullfile('tests', fname));
[~, data.evalinds] = reg.trainAndTest(data.X, data.Y, 0.5);
M = asd.linearASDStruct(data.D);
mlFcn = @(~) ml.fitopts('gauss');
isLinReg = true;
cd tests
updateFits(fname, data, M, mlFcn, isLinReg);
