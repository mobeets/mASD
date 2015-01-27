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

Load some data: X (stimulus), Y (response), Xxy (spatial locations of X's columns), ns, nt (space and time filter sizes)

```
[X, Y, D, Xxy, ns, nt] = loadData('data/XY.mat'); % write your own
```

Initialize data, hypergrid, and functions for ASD logistic regression


```
hypergrid = asd.makeHyperGrid(nan, nan, nan, data.ndeltas, false, false);
M = asd.logisticASDStruct(D);
fitFcn = M.mapFcn;
fitOpts = M.mapFcnOpts;
scFcn = M.rsqFcn;
scFcnOpts = {};
```

Fit on 10-fold cross-validation

```
[X_train, Y_train, X_test, Y_test] = reg.trainAndTestKFolds(X, Y, 10);
ASD = reg.cvFitAndScore(X_train, Y_train, X_test, Y_test, hypergrid, fitFcn, scFcn, fitOpts, scFcnOpts);
```

Plot kernel

```
rsq = ASD.scores(1);
wf = ASD.mus{1};
plot.prepAndPlotKernel(Xxy, wf, ns, nt, 1, 'ASD', rsq);
```
