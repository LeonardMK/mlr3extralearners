#' @title Regression Neural Network Learner
#'
#' @name mlr_learners_regr.nnet
#'
#' @description
#' Single Layer Neural Network.
#' Calls [nnet::nnet.formula()] from package \CRANpkg{nnet}.
#'
#' Note that modern neural networks with multiple layers are connected
#' via package [mlr3keras](https://github.com/mlr-org/mlr3keras).
#'
#' @template section_dictionary_learner
#' @templateVar id regr.nnet
#'
#' @section Custom mlr3 defaults:
#' - `size`:
#'   - Adjusted default: 3L.
#'   - Reason for change: no default in `nnet()`.
#'
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrNnet = R6Class("LearnerRegrNnet",
                          inherit = LearnerRegr,
                          public = list(
                              #' @description
                              #' Creates a new instance of this [R6][R6::R6Class] class.
                              initialize = function() {
                                  
                                  ps = ps(
                                      Hess      = p_lgl(default = FALSE, tags = "train"),
                                      MaxNWts   = p_int(1L, default = 1000L, tags = "train"),
                                      Wts       = p_uty(tags = "train"),
                                      abstol    = p_dbl(default = 1.0e-4, tags = "train"),
                                      contrasts = p_uty(default = NULL, tags = "train"),
                                      decay     = p_dbl(default = 0, tags = "train"),
                                      mask      = p_uty(tags = "train"),
                                      maxit     = p_int(1L, default = 100L, tags = "train"),
                                      na.action = p_uty(tags = "train"),
                                      rang      = p_dbl(default = 0.7, tags = "train"),
                                      reltol    = p_dbl(default = 1.0e-8, tags = "train"),
                                      size      = p_int(0L, default = 3L, tags = "train"),
                                      skip      = p_lgl(default = FALSE, tags = "train"),
                                      subset    = p_uty(tags = "train"),
                                      trace     = p_lgl(default = TRUE, tags = "train")
                                  )
                                  ps$values = list(size = 3L)
                                  
                                  super$initialize(
                                      id = "regr.nnet",
                                      packages = "nnet",
                                      feature_types = c("integer", "numeric", "factor", "ordered"),
                                      predict_types = c("response"),
                                      param_set = ps,
                                      properties = c("weights"),
                                      man = "mlr3extralearners::mlr_learners_regr.nnet"
                                  )
                              }
                          ),
                          
                          private = list(
                              .train = function(task) {
                                  pv = self$param_set$get_values(tags = "train")
                                  if ("weights" %in% task$properties) {
                                      pv = insert_named(pv, list(weights = task$weights$weight))
                                  }
                                  formula = task$formula()
                                  data = task$data()
                                  invoke(nnet::nnet.formula, formula = formula, data = data, .args = pv, linout = TRUE)
                              },
                              
                              .predict = function(task) {
                                  
                                  newdata = task$data(cols = task$feature_names)
                                  
                                  response = invoke(predict, self$model, newdata = newdata, type = "raw")
                                  return(list(response = response))
                              }
                          )
)
.extralrns_dict$add("regr.nnet", LearnerRegrNnet)

