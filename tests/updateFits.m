function data = updateFits(fname, data, llstr, objML, objASD, scoreObj)
% data is a struct containing, at minimum, the fields X, Y, Xxy, and nt

    % verify erasing of previous results
    if ~checkContinue()
        return;
    end
    if nargin < 4
        objML = struct();
    end
    if nargin < 5
        objASD = struct();
    end
    if nargin < 6
        scoreObj = struct();
    end
    
    X = data.X;
    Y = data.Y;
    D = asd.sqdist.spaceTime(data.Xxy, data.nt);
    if isempty(fieldnames(scoreObj))
        if strcmp(llstr, 'gauss')
            scoreObj = reg.getScoreObj('rsq', true);
        elseif strcmp(llstr, 'bern')
            scoreObj = reg.getScoreObj('pctCorrect', false);
        end
    end
    objML = reg.getObj_ML(X, Y, objML);
    objML = reg.fitAndScore(X, Y, objML, scoreObj);
    objASD = reg.getObj_ASD(X, Y, D, scoreObj, objASD);
    objASD = reg.fitAndScore(X, Y, objASD, scoreObj);
    
    objML = tools.rmfieldsRegexp(objML, {'Fcn$', 'FcnArgs$'}, true);
    objASD = tools.rmfieldsRegexp(objASD, {'Fcn$', 'FcnArgs$'}, true);
    
    data.ML = objML;
    data.ASD = objASD;
    data.D = D;
    
    save(fname, '-struct', 'data');
end
