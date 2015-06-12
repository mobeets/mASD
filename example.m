% rng(110);

%% truth

nt = 1000;
nw = 20;
Xxy = randn(nw,2);
D = asd.sqdist.space(Xxy);
w = mvnrnd(zeros(nw,1), asd.prior(2, D, 1))';
% figure(1); clf; plot.plotKernelSingle(Xxy, w, nan, 50); title('truth');

X = rand(nt,nw);
e = randn(nt,1);
Y = X*w + 2*e;
isLinReg = true;

%% ASD

clear obj
scoreObj = reg.getScoreObj(isLinReg, 'rsq');
ASD = reg.getObj_ASD(X, Y, D);
ASD = reg.fitAndScore(X, Y, ASD, scoreObj);
% figure(2); clf; plot.plotKernelSingle(Xxy, ASD.w, nan, 50); title('ASD');

%% ML

clear obj
scoreObj = reg.getScoreObj(isLinReg, 'rsq');
ML = reg.getObj_ML(X, Y);
ML = reg.fitAndScore(X, Y, ML, scoreObj);
% figure(3); clf; plot.plotKernelSingle(Xxy, ML.w, nan, 50); title('ML');

%%

% figure(4); clf; hold on;
% f = reg.getPredictionFcn(isLinReg);
% scatter(Y, Y-f(X,ASD.mu), 'b');
% scatter(Y, Y-f(X,ML.mu), 'g');

disp(' ');
disp('avg r-sq scores across 5-fold c-v');
disp('---------------------------------');
disp(['ASD = ' num2str(ASD.score) ', ML = ' num2str(ML.score)]);
