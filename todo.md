
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
