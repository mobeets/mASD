function fitopts = fitBernML()
    fitopts.fitIntercept = true;
    fitopts.centerX = false;
    fitopts.hyperFcn = @(X, Y, hyper) hyper;
    fitopts.hyperFcnArgs = {nan};
    fitopts.muFcn = @ml.calcBernML;
    fitopts.muFcnArgs = {};  
end
