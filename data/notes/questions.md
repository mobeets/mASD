# Process

1. make 10-folds, where each fold yields a 90% training set, and 10% testing set. for each fold:
    2. grid up hyperparameter space. for each hyperparameter:
        3. find wMAP of training set by minimizing negative log posterior (given current hyperparameter):
            = -loglikelihood(w) - logprior(w, hyper)
        4. score/evaluate this w by calculating the loglikelihood(w) on testing set
5. take the mean score across folds of values calculated in #4.
6. find the maximum

## Q: fitting intercept (where?)

## Q: logistic prediction function, given wMAP

`
f = @(X) tools.logistic(X);
rsqFcn = @(X_test, R_test, w, hyper, opts) reg.rsq(f(X_test)*w(1:end-1) + w(end), R_test);
`
