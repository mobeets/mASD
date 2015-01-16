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
