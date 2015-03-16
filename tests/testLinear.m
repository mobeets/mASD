function tests = testLinear
    tests = functiontests(localfunctions);
end

function setup(testCase)
    cd('..');
end

function testLinear1(testCase)
    data = load('tests/testDataLinear.mat');
    llstr = 'gauss';
    scorestr = 'rsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);

    isLinReg = true;
    fit = 'ASD';
    [~, ~, ASD] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    isequaln(ASD, data.ASD);

end

function testLinear2(testCase)
    data = load('tests/testDataLinear.mat');
    llstr = 'gauss';
    scorestr = 'rsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);
    isLinReg = true;
    fit = 'ML';
    [~, ~, ML] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    isequaln(ML, data.ML);
end

function testLinear3(testCase)
    data = load('tests/testDataLinear.mat');
    llstr = 'gauss';
    scorestr = 'rsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);
    isLinReg = true;
    fit = 'ASD_gs';
    [~, ~, ASD_gs] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    isequaln(ASD_gs, data.ASD_gs);
end

function testLinear4(testCase)
    data = load('tests/testDataLinear.mat');
    llstr = 'gauss';
    scorestr = 'rsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);
    isLinReg = true;
    fit = '';
    [D, hypergrid, ~] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    assert(all(D(:) == data.D(:)));
    assert(all(hypergrid(:) == data.hypergrid(:)));
end

function testLinear5(testCase)
    data = load('tests/testDataLinear.mat');
    llstr = 'gauss';
    scorestr = 'rsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);
    isLinReg = true;
    fit = 'ASD_mother';
    [~, ~, ASD_m] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    isequaln(ASD_m, data.ASD_m);
end

function testLinear6(testCase)
    data = load('tests/testDataLinear.mat');
    llstr = 'gauss';
    scorestr = 'rsq';
    scoreFcn = reg.scoreFcns(scorestr, llstr);
    MAP = @(hyper) asd.fitHandle(hyper, data.D, llstr);
    ML = @(~) ml.fitHandle(llstr);
    isLinReg = true;
    fit = 'ASD_gs_mother';
    [~, ~, ASD_gs_m] = runFits(data, MAP, ML, scoreFcn, isLinReg, fit);
    
    isequaln(ASD_gs_m, data.ASD_gs_m);
end
