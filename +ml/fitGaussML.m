function fitopts = fitGaussML()
    fitopts.fitIntercept = true;
    fitopts.centerX = false;
    fitopts.hyperFcn = @(X, Y, hyper) hyper;
    fitopts.hyperFcnArgs = {nan};
    fitopts.muFcn = @ml.calcGaussML;
    fitopts.muFcnArgs = {};  
end
