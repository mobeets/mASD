cd ..
fname = 'testDataLinear.mat';
data = load(fullfile('tests', fname));
cd tests
updateFits(fname, data, 'gauss');
