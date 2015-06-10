function tests = testLinearNew
    tests = functiontests(localfunctions);
end

function setup(testCase)
    cd('..');
end

function testLinearNew1(testCase)
    data = load('tests/testDataLinear.mat');
    llstr = 'gauss';
    scorestr = 'rsq';
    X = data.X;
    Y = data.Y;
    D = data.D;

    scoreObj = reg2.getScoreObj(scorestr, false);
    obj.foldinds = data.foldinds;
    obj = reg2.getObj_ML(X, Y, obj);
    ML = reg2.fitAndScore(X, Y, obj, scoreObj);
    ML = tools.rmfieldsRegexp(ML, {'Fcn$', 'FcnArgs$'}, true);
    isequaln(ML, data.ML);

end

function testLinearNew2(testCase)
    data = load('tests/testDataLinear.mat');
    llstr = 'gauss';
    scorestr = 'rsq';
    X = data.X;
    Y = data.Y;
    D = data.D;

    scoreObj = reg2.getScoreObj(scorestr, false);
    obj.foldinds = data.foldinds;
    obj = reg2.getObj_ASD(X, Y, D, scoreObj, obj);
    ASD = reg2.fitAndScore(X, Y, obj, scoreObj);
    ASD = tools.rmfieldsRegexp(ASD, {'Fcn$', 'FcnArgs$'}, true);
    isequaln(ASD, data.ASD);

end
