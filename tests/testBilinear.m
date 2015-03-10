function tests = testBilinear
    tests = functiontests(localfunctions);
end

function setup(testCase)
    cd('..');
end

function testBilinear1(testCase)
    data = load('tests/testDataBilinear.mat');
    mu = runBilinear();
    assert(all(data.mu(:) == mu(:)));
end
