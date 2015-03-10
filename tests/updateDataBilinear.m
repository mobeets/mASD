if ~checkContinue()
    return;
end
mu.normal = runBilinear(false);
mu.reshaped = runBilinear(true);
fname = 'testDataBilinear.mat';
save(fname, '-struct', 'mu');
