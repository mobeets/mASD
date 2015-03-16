function tests = testLogistic
    tests = functiontests(localfunctions);
end

function setup(testCase)
    cd('..');
end

function testLogistic1(testCase)
    data = load('tests/testDataLogistic.mat');
    llstr = 'bern';
    scorestr = 'pseudoRsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);
    isLinReg = false;
    fit = 'ASD';
    [~, ~, ASD] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    isequaln(ASD, data.ASD);

end

function testLogistic2(testCase)
    data = load('tests/testDataLogistic.mat');
    llstr = 'bern';
    scorestr = 'pseudoRsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);
    isLinReg = false;
    fit = 'ML';
    [~, ~, ML] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    isequaln(ML, data.ML);
end

function testLogistic3(testCase)
    data = load('tests/testDataLogistic.mat');
    llstr = 'bern';
    scorestr = 'pseudoRsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);
    isLinReg = false;
    fit = 'ASD_gs';
    [~, ~, ASD_gs] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    isequaln(ASD_gs, data.ASD_gs);
end

function testLogistic4(testCase)
    data = load('tests/testDataLogistic.mat');
    llstr = 'bern';
    scorestr = 'pseudoRsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);
    isLinReg = false;
    fit = '';
    [D, hypergrid, ~] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    assert(all(D(:) == data.D(:)));
    assert(all(hypergrid(:) == data.hypergrid(:)));
end
