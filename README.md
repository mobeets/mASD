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

Load some data: X (stimulus), Y (response), D (squared distance matrix).

```
[X, Y, D] = loadData('data/XY.mat'); % write your own
```

Initialize hypergrid (with default bounds) and functions for ASD and ML logistic regression.


```
lbs = [-3, -5 -5]; ubs = [3, 10 10]; ns = 5*ones(1,3);
hypergrid = exp(tools.gridCartesianProduct(lbs, ubs, ns));
M = asd.logisticASDStruct(D);
mapFcn = M.mapFcn;
scoreFcn = M.rsqFcn;
mlFcn = @(~) ml.fitopts('bern');
```

Fit on 10-fold cross-validation.

```
nfolds = 10;
[~,~,~,~,foldinds] = reg.trainAndTestKFolds(X, Y, nfolds);
ASD = reg.cvMaxScoreGrid(data, hypergrid, mapFcn, {}, scoreFcn, {}, foldinds, 'ASD', 1);
ML = reg.cvMaxScoreGrid(data, [nan nan nan], mlFcn, {}, scoreFcn, {}, foldinds, 'ML', 1);
```

Plot kernel given Xxy (spatial locations of X's columns), ns, nt (space and time filter sizes).

```
rsq = ASD.scores(1); wf = ASD.mus{1};
plot.prepAndPlotKernel(Xxy, wf, ns, nt, 1, 'ASD', rsq);
```

## Testing framework

Running tests:

```
>> runtests('tests/testLinear.m')
>> runtests('tests/testLogistic.m')
```

Updating tests:

```
>> cd tests
>> updateDataLinear
>> updateDataLogistic
```
