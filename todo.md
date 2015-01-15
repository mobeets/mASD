
## my additions

* k-fold cross-validation
* nd hyperparameter gridding

## ncc path

* logistic framework all good to go
* BUT only 3d hyperparameter gridding

## logistic regression

1. grid hyperparameters, minimize logpost to find wMAP, score is logevi
2. at best hyperparameter(s), minimize logevi

## FOR NOW

### step 1

* copy: gridsearch_GLMevidence, neglogpost_GLM, neglogli_*
* define mstruct (with ASD prior)
* rewrite gridsearch_GLMevidence to take hh as input (for nd gridding rather than a max of 3d)

### step 2
* copy logevid_GLM

# 2015-01-12

* use C-G
* ncc: just use bernoulli neglogli and forget the rest for now
* no evidence -- evaluate neglogli on withheld data
* gauss covariance function to calculate gradient, hessian, etc. - take isInv flag



# 2015-01-15

## Question:

* in gaussian loglikelihood, this includes the constant, right?
* so in tools.neglogli_bernoulliGLM, i should also be including constant, right?
* at least when calling it on test data, since the X and Y aren't mean-corrected

## Why is SigmaInv singular so often in gaussian ASD?

