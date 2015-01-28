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
    runFits(data, M, mlFcn, isLinReg);
end
