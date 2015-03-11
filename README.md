# ASD

__Source__: _Evidence Optimization Techniques for Estimating Stimulus-Response Functions_ [(Sahani, Linden; 2002)](http://papers.nips.cc/paper/2294-evidence-optimization-techniques-for-estimating-stimulus-response-functions)

ASD is a method for estimating the space-time weights/kernel in a Bayesian regression framework where the values of the weights are expected to vary smoothly in space or in time (or both). There are two contexts:

* linear regression (Gaussian or Poisson likelihood)
* logistic regression (Bernoulli likelihood)

n.b. The Gaussian likelihood has a closed-form solution while the others do not.

Kernel assumptions:

* full (default)
* bilinear (space and time filters assumed separable)

### Hyperparameters

The ASD prior requires setting three or so hyperparameters determining the shrinkage, noise variance (Gaussian likelihood only), and smoothing (e.g., in space and/or in time). The best hyperparameters are chosen by gridding the hyperparameter search space and then picking the hyperparameter that minimizes the prediction error on test data. (Optionally, you can then repeat this process on a finer search grid of hyperparameters centered around the previous best hyperparameter.)

## Testing framework

Running tests:

```
>> runtests('tests/testLinear.m')
>> runtests('tests/testLogistic.m')
>> runtests('tests/testBilinear.m')
```

Updating tests:

```
>> cd tests
>> updateDataLinear
>> updateDataLogistic
>> updateDataBilinear
```
