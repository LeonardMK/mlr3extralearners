# clearly this should be a Dictionary but there's a weird bug that leads to objects
# being handled wrong and not cloned properly when loaded from dictionary in `mlr3::lrn`
.extralrns_dict = R6Class(".extralrns_dict",
  public = list(
    lrns = list(),
    add = function(key, learn) {
      assert_character(key, len = 1)
      assert_class(learn, "R6ClassGenerator")
      lst = list(key = learn)
      names(lst) = key
      self$lrns = mlr3misc::insert_named(self$lrns, lst)
    })
)$new()
