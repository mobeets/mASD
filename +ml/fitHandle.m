function obj = fitHandle(llstr)    
    obj.hyperFcn = @(X, Y, hyper) hyper;
    obj.hyperFcnArgs = {nan};
    obj.fitIntercept = true;
    if strcmp(llstr, 'gauss')
        obj.muFcn = @ml.calcGaussML;
        obj.predictionFcn = @(X, w) X*w;
    elseif strcmp(llstr, 'bern')
        obj.muFcn = @ml.calcBernML;
        obj.predictionFcn = @(X, w) tools.logistic(X*w);
%         opts.fitIntercept = false; % only fitting 0/1
    elseif strcmp(llstr, 'poiss')
        obj.muFcn = @ml.calcPoissML;
        obj.predictionFcn = @(X, w) X*w;
    end
    obj.muFcnArgs = {};    
    obj.centerX = false;
end
