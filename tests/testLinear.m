function tests = testLinear
    tests = functiontests(localfunctions);
end

function setup(testCase)
    cd('..');
end

function testLinear1(testCase)
    data = load('tests/testDataLinear.mat');
    X = data.X;
    Y = data.Y;
    D = data.D;

    scoreObj = reg.getScoreObj('rsq', true);
    obj.foldinds = data.foldinds;
    obj = reg.getObj_ML(X, Y, obj);
    ML = reg.fitAndScore(X, Y, obj, scoreObj);
    ML = tools.rmfieldsRegexp(ML, {'Fcn$', 'FcnArgs$'}, true);
    isequaln(ML, data.ML);

end

function testLinear2(testCase)
    data = load('tests/testDataLinear.mat');
    X = data.X;
    Y = data.Y;
    D = data.D;

    scoreObj = reg.getScoreObj('rsq', true);
    obj.foldinds = data.foldinds;
    obj = reg.getObj_ASD(X, Y, D, scoreObj, obj);
    ASD = reg.fitAndScore(X, Y, obj, scoreObj);
    ASD = tools.rmfieldsRegexp(ASD, {'Fcn$', 'FcnArgs$'}, true);
    isequaln(ASD, data.ASD);

end
