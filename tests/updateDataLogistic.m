cd ..
fname = 'testDataLogistic.mat';
data = load(fullfile('tests', fname));
cd tests
updateFits(fname, data, 'bern');
