if ~checkContinue()
    return;
end
mu = runBilinear();
fname = 'testDataBilinear.mat';
save(fname, 'mu');
