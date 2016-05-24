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
Y = X*w + 2*e;
isLinReg = false;

if ~isLinReg
%     Y = double(Y - prctile(Y, 40) > 0);
    Y = double(tools.logistic(Y) >= 0.5);
%     scoreType = 'mcc';
    scoreType = 'pctCorrect';
else
    scoreType = 'rsq';
end

%% fit and score

% ASD
scoreObj = reg.getScoreObj(isLinReg, scoreType);
ASD = reg.getObj_ASD(X, Y, D, scoreObj);
ASD = reg.fitAndScore(X, Y, ASD, scoreObj);

% ML
scoreObj = reg.getScoreObj(isLinReg, scoreType);
ML = reg.getObj_ML(X, Y);
ML = reg.fitAndScore(X, Y, ML, scoreObj);

%% plot results

cmn = floor(min([w; ASD.w; ML.w]));
sz = 100;
figure; set(gcf, 'color', 'w');
subplot(2,2,1); hold on;
plot.rfSingle(Xxy, w, cmn, sz); axis off; title('true');
subplot(2,2,2); hold on;
plot.rfSingle(Xxy, ASD.w, cmn, sz); axis off; title('ASD');
subplot(2,2,3); hold on;
plot.rfSingle(Xxy, ML.w, cmn, sz); axis off; title('ML');
subplot(2,2,4); hold on;
bar(1:2, [ASD.score ML.score], 'FaceColor', 'w');
set(gca, 'XTick', 1:2, 'XTickLabel', {'ASD', 'ML'});
ylim([0 1]);
ylabel(['score (' scoreType ')']);

% f = reg.getPredictionFcn(isLinReg);
% YhASD = f(X, ASD.mu); YhML = f(X, ML.mu);
% if isLinReg
%     scatter(Y, Y-YhASD, 'b.');
%     scatter(Y, Y-YhML, 'g.');
%     xlabel('true Y'); ylabel('errors');
% end

% disp(' ');
% disp('avg r-sq scores across 5-fold c-v');
% disp('---------------------------------');
% disp(['ASD = ' num2str(ASD.score) ', ML = ' num2str(ML.score)]);
