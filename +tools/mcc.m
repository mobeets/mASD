function v = mcc(Ytrue, Ypred)
% function v = mcc(Ytrue, Ypred)
% 
% calculates matthew's correlation coefficient
% returns a value between -1 and 1
% 
    assert(~isempty(Ytrue) && ~isempty(Ypred));
    C0 = min([min(Ytrue), min(Ypred)]);
    C1 = max([max(Ytrue), max(Ypred)]);
    
    A0 = Ytrue == C0;
    A1 = Ytrue == C1;
    B0 = Ypred == C0;
    B1 = Ypred == C1;
    
    TP = sum(A1 & B1);
    FN = sum(A1 & B0);
    FP = sum(A0 & B1);
    TN = sum(A0 & B0);
    
    v = (TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
end
