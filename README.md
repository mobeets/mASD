# ASD

__Source__: _Evidence Optimization Techniques for Estimating Stimulus-Response Functions_ [(Sahani, Linden; 2002)](http://papers.nips.cc/paper/2294-evidence-optimization-techniques-for-estimating-stimulus-response-functions)

There are two options:

* linear regression (Gaussian or Poisson likelihood)
* logistic regression (Bernoulli likelihood)

The Gaussian likelihood has a closed-form solution while the others do not.

## Current approach

1. Grid the hyperparameter space.
2. Divide data into _n_ folds of training and testing sets. For each fold:
3. For each hyperparameter, using the training set of the current fold to fit a set of weights.
4. For the current set of weights, use the testing set to score the fit (e.g., r-squared, or log-likelihood).
5. Choose the hyperparameter with the maximum mean score across folds.

### Example

Initialize data, hypergrid, and functions for ASD logistic regression

```
data = loadData('data/XY.mat');
hypergrid = asd.makeHyperGrid(nan, nan, nan, data.ndeltas, false, false);
M = asd.logisticASDStruct(data.D);
fitFcn = M.mapFcn;
scFcn = M.rsqFcn;
fitOpts = M.mapFcnOpts;
```

Fit on 10-fold cross-validation

```
[X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(data.X, data.R, 10);
ASD = reg.cvFitAndScore(X_train, Y_train, X_test, Y_test, hypergrid, fitFcn, scFcn, fitOpts, {});
```

Plot kernel

```
rsq = ASD.scores(1);
wf = ASD.mus{1};
plot.prepAndPlotKernel(data.Xxy, wf, data.ns, data.nt, 1, 'ASD', rsq);
```
