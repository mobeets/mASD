function [fcn, obj] = scoreFcns(scorestr, llstr)
    if strcmpi(llstr, 'bern')
        obj = reg.logisticRegressionScoreFcns();
    else
        obj = reg.linearRegressionScoreFcns(llstr);
    end
    fcn = obj.([scorestr 'Fcn']);
end
