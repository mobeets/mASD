% To generate example.png:
% 1. Get plotKernelSingle from https://github.com/mobeets/gaborMotionPulses
% 2. Uncomment the rng line below to set seed
% 3. Uncomment the plot lines

rng(101);

%% truth

Xxy = tools.gridCartesianProduct([0 0], [2 2], [5 5]);
nw = size(Xxy, 1);
nt = 1000;

D = asd.sqdist.space(Xxy);
w = mvnrnd(zeros(nw,1), asd.prior(2, D, 1))';

X = rand(nt,nw)-1;
e = randn(nt,1);
Y = X*w + 3*e;
isLinReg = true;

%% ASD

clear obj
scoreObj = reg.getScoreObj(isLinReg, 'rsq');
ASD = reg.getObj_ASD(X, Y, D);
ASD = reg.fitAndScore(X, Y, ASD, scoreObj);

%% ML

clear obj
scoreObj = reg.getScoreObj(isLinReg, 'rsq');
ML = reg.getObj_ML(X, Y);
ML = reg.fitAndScore(X, Y, ML, scoreObj);

%%

figure(1); clf; axis off; title('truth');
plot.plotKernelSingle(Xxy, w, nan, 130);
figure(2); clf; axis off; title('ASD');
plot.plotKernelSingle(Xxy, ASD.w, nan, 130);
figure(3); clf; axis off; title('ML');
plot.plotKernelSingle(Xxy, ML.w, nan, 130);
figure(4); clf; hold on;
f = reg.getPredictionFcn(isLinReg);
scatter(Y, Y-f(X,ASD.mu), 'b');
scatter(Y, Y-f(X,ML.mu), 'g');

disp(' ');
disp('avg r-sq scores across 5-fold c-v');
disp('---------------------------------');
disp(['ASD = ' num2str(ASD.score) ', ML = ' num2str(ML.score)]);
