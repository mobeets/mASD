function tests = testBilinear
    tests = functiontests(localfunctions);
end

function setup(testCase)
    cd('..');
end

function testBilinear1(testCase)
    mu0 = load('tests/testDataBilinear.mat');
    mu = runBilinear(false);
    assert(all(mu0.normal(:) == mu(:)));
end

function testBilinear2(testCase)
    mu0 = load('tests/testDataBilinear.mat');
    mu = runBilinear(true);
    assert(all(mu0.reshaped(:) == mu(:)));
end
