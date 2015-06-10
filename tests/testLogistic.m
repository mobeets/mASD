function tests = testLogistic
    tests = functiontests(localfunctions);
end

function setup(testCase)
    cd('..');
end

function testLogistic1(testCase)
    data = load('tests/testDataLogistic.mat');
    X = data.X;
    Y = data.Y;
    D = data.D;

    scoreObj = reg.getScoreObj('pctCorrect', false);
    obj.foldinds = data.foldinds;
    obj = reg.getObj_ASD(X, Y, D, scoreObj, obj);
    ASD = reg.fitAndScore(X, Y, obj, scoreObj);
    ASD = tools.rmfieldsRegexp(ASD, {'Fcn$', 'FcnArgs$'}, true);
    isequaln(ASD, data.ASD);

end
