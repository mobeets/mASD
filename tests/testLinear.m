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
    [D, hypergrid, ASD, ML, ASD_gs] = runFits(data, M, mlFcn, isLinReg);
    
    assert(all(D(:) == data.D(:)));
    assert(all(hypergrid(:) == data.hypergrid(:)));
    
    mus = cell2mat(ASD.mus);
    mus1 = cell2mat(data.ASD.mus);
    assert(all(ASD.scores(:) == data.ASD.scores(:)));
    assert(all(ASD.hyprs(:) == data.ASD.hyprs(:)));
    assert(all(mus(:) == mus1(:)));

    mus = cell2mat(ML.mus);
    mus1 = cell2mat(data.ML.mus);
    assert(all(ML.scores(:) == data.ML.scores(:)));
    assert(all(mus(:) == mus1(:)));

    mus = cell2mat(ASD_gs.mus);
    mus1 = cell2mat(data.ASD_gs.mus);
    scores = cell2mat(ASD_gs.scores);
    scores1 = cell2mat(data.ASD_gs.scores);
    hyprs = cell2mat(ASD_gs.hyprs);
    hyprs1 = cell2mat(data.ASD_gs.hyprs);
    assert(all(scores(:) == scores1(:)));
    assert(all(hyprs(:) == hyprs1(:)));
    assert(all(mus(:) == mus1(:)));

end
