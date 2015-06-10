function obj = getObj_ASD(X, Y, D, scoreObj, obj)
    if nargin < 4
        scoreObj = struct();
    end
    if nargin < 5
        obj = struct();
    end
    obj = reg2.getObj(X, Y, obj);

    if strcmpi(obj.llstr, 'bern')
        obj.fitFcn = @asd.bern.calcMAP;        
    elseif strcmpi(obj.llstr, 'gauss')
        obj.fitFcn = @asd.gauss.calcMAP;
    elseif strcmpi(obj.llstr, 'poiss')
        obj.fitFcn = @asd.poiss.calcMAP;
    end
    obj.fitFcnArgFcn = @(obj) {obj.hyper, D};

    if ~isfield(obj, 'hyperObj')
        if strcmp(obj.llstr, 'gauss')
            obj.hyperObj = reg2.getHyperObj_gauss(D);
        else
            obj.hyperObj = reg2.getHyperObj_grid(X, Y, obj, scoreObj);
        end
    end
end
