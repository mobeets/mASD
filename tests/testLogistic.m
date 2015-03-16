function tests = testLogistic
    tests = functiontests(localfunctions);
end

function setup(testCase)
    cd('..');
end

function testLogistic1(testCase)
    data = load('tests/testDataLogistic.mat');
    M = asd.logisticASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('bern');
    isLinReg = false;
    fit = 'ASD';
    [~, ~, ASD] = runFits(data, M, mlFcn, isLinReg, fit);
    
    mus = cell2mat(ASD.mus);
    mus1 = cell2mat(data.ASD.mus);
    assert(all(ASD.scores(:) == data.ASD.scores(:)));
    assert(all(ASD.hyprs(:) == data.ASD.hyprs(:)));
    assert(all(mus(:) == mus1(:)));

end

function testLogistic2(testCase)
    data = load('tests/testDataLogistic.mat');
    M = asd.logisticASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('bern');
    isLinReg = false;
    fit = 'ML';
    [~, ~, ML] = runFits(data, M, mlFcn, isLinReg, fit);
    
    mus = cell2mat(ML.mus);
    mus1 = cell2mat(data.ML.mus);
    assert(all(ML.scores(:) == data.ML.scores(:)));
    assert(all(mus(:) == mus1(:)));
end

function testLogistic3(testCase)
    data = load('tests/testDataLogistic.mat');
    M = asd.logisticASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('bern');
    isLinReg = false;
    fit = 'ASD_gs';
    [~, ~, ASD_gs] = runFits(data, M, mlFcn, isLinReg, fit);
    
    mus = ASD_gs.mus;
    mus1 = data.ASD_gs.mus;
    scores = ASD_gs.scores;
    scores1 = data.ASD_gs.scores;
    hyprs = ASD_gs.hyprs;
    hyprs1 = data.ASD_gs.hyprs;
    assert(all(scores(:) == scores1(:)));
    assert(all(hyprs(:) == hyprs1(:)));
    assert(all(mus(:) == mus1(:)));
end

function testLogistic4(testCase)
    data = load('tests/testDataLogistic.mat');
    M = asd.logisticASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('bern');
    isLinReg = false;
    fit = '';
    [D, hypergrid, ~] = runFits(data, M, mlFcn, isLinReg, fit);
    
    assert(all(D(:) == data.D(:)));
    assert(all(hypergrid(:) == data.hypergrid(:)));
end
