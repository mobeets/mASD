cd ..
fname = 'testDataLogistic.mat';
data = load(fullfile('tests', fname));
[~, data.evalinds] = reg.trainAndTest(data.X, data.Y, 0.5);

llstr = 'bern';
scorestr = 'pseudoRsq';
scoreFcn = reg.scoreFcns(scorestr, llstr);
MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
ML = @(~) ml.fitHandle(llstr);

isLinReg = false;
cd tests
updateFits(fname, data, MAP, ML, scoreFcn, isLinReg);
