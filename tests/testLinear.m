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
    runFits(data, M, mlFcn, isLinReg);
end
