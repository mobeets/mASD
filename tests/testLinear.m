function tests = testLinear
    tests = functiontests(localfunctions);
end

function setup(testCase)
    cd('..');
end

function testLinear1(testCase)
    data = load('tests/testDataLinear.mat');
    M = asd.linearASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('gauss');
    isLinReg = true;
    fit = 'ASD';
    [D, hypergrid, ASD] = runFits(data, M, mlFcn, isLinReg, fit);
    
    assert(all(D(:) == data.D(:)));
    assert(all(hypergrid(:) == data.hypergrid(:)));
    
    mus = cell2mat(ASD.mus);
    mus1 = cell2mat(data.ASD.mus);
    assert(all(ASD.scores(:) == data.ASD.scores(:)));
    assert(all(ASD.hyprs(:) == data.ASD.hyprs(:)));
    assert(all(mus(:) == mus1(:)));

end

function testLinear2(testCase)
    data = load('tests/testDataLinear.mat');
    M = asd.linearASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('gauss');
    isLinReg = true;
    fit = 'ML';
    [~, ~, ML] = runFits(data, M, mlFcn, isLinReg, fit);
    
    mus = cell2mat(ML.mus);
    mus1 = cell2mat(data.ML.mus);
    assert(all(ML.scores(:) == data.ML.scores(:)));
    assert(all(mus(:) == mus1(:)));
end

function testLinear3(testCase)
    data = load('tests/testDataLinear.mat');
    M = asd.linearASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('gauss');
    isLinReg = true;
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

function testLinear4(testCase)
    data = load('tests/testDataLinear.mat');
    M = asd.linearASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('gauss');
    isLinReg = true;
    fit = '';
    [D, hypergrid, ~] = runFits(data, M, mlFcn, isLinReg, fit);
    
    assert(all(D(:) == data.D(:)));
    assert(all(hypergrid(:) == data.hypergrid(:)));
end

function testLinear5(testCase)
    data = load('tests/testDataLinear.mat');
    M = asd.linearASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('gauss');
    isLinReg = true;
    fit = 'ASD_mother';
    [~, ~, ASD_m] = runFits(data, M, mlFcn, isLinReg, fit);
    
    isequaln(ASD_m, data.ASD_m);
end

function testLinear6(testCase)
    data = load('tests/testDataLinear.mat');
    M = asd.linearASDStruct(data.D);
    mlFcn = @(~) ml.fitopts('gauss');
    isLinReg = true;
    fit = 'ASD_gs_mother';
    [~, ~, ASD_gs_m] = runFits(data, M, mlFcn, isLinReg, fit);
    
    isequaln(ASD_gs_m, data.ASD_gs_m);
end
