#this function calculates the pointwise (by calling pointwise_comparisons.R) CI and the simultaneous CI
# for a pairwise comparison between two smooths
difference_smooths <- function(model,
                               smooth,
                               n = 100,
                               ci_level = 0.95,
                               newdata = NULL,
                               partial_match = TRUE,
                               unconditional = FALSE,
                               frequentist = FALSE,
                               nrep = 10000,
                               include_means = TRUE,
                               ...) {
    if (missing(smooth)) {
        stop("Must specify a smooth to difference via 'smooth'.")
    }

    # smooths in model
    S <- gratia::smooths(model) # vector of smooth labels - "s(x)"
    # select smooths
    select <-
        gratia:::check_user_select_smooths(smooths = S, select = smooth,
                                           partial_match = partial_match)#,
    # model_name = expr_label(substitute(object)))
    sm_ids <- which(select)
    smooths <- gratia::get_smooths_by_id(model, sm_ids)
    sm_data <- map(sm_ids, gratia:::smooth_data,
                   model = model, n = n, include_all = TRUE)
    sm_data <- bind_rows(sm_data)
    by_var <- by_variable(smooths[[1L]])
    smooth_var <- gratia:::smooth_variable(smooths[[1L]])
    pairs <- as_tibble(as.data.frame(t(combn(levels(sm_data[[by_var]]), 2)),
                                     stringsAsFactor = FALSE))
    names(pairs) <- paste0("f", 1:2)

    Xp <- predict(model, newdata = sm_data, type = "lpmatrix")
    V <- gratia:::get_vcov(model, unconditional = unconditional,
                           frequentist = frequentist)
    coefs <- coef(model)

    out <- pmap(pairs, difference_pointwise, smooth = smooth, by_var = by_var,
                smooth_var = smooth_var, data = sm_data, Xp = Xp, V = V,
                coefs = coefs, nrep = nrep)
    out <- bind_rows(out)
    crit <- qnorm((1 - ci_level) / 2, lower.tail = FALSE)

    out <- add_column(out,
                      lower = out$diff - (crit * out$se),
                      upper = out$diff + (crit * out$se),
                      .after = 6L)
    out
}
