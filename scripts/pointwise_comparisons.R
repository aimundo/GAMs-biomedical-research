##this function determines the pointwise confidence interval of a difference between two smooths

difference_pointwise <- function(f1, f2, smooth, by_var, smooth_var, data, Xp, V, coefs, nrep = 1000) {
    ## make sure f1 and f2 are characters
    f1 <-  as.character(f1)
    f2 <-  as.character(f2)
    cnames <- colnames(Xp)
    ## columns of Xp associated with pair of smooths
    c1 <- grepl(gratia:::mgcv_by_smooth_labels(smooth, by_var, f1), cnames, fixed = TRUE)
    c2 <- grepl(gratia:::mgcv_by_smooth_labels(smooth, by_var, f2), cnames, fixed = TRUE)
    ## rows of Xp associated with pair of smooths
    r1 <- data[[by_var]] == f1
    r2 <- data[[by_var]] == f2

    ## difference rows of Xp for pair of smooths
    X <- Xp[r1, ] - Xp[r2, ]

    ######IMPORTANT: uncommenting the following two lines
    #removes the group means from the comparison######

    ## zero the cols related to other splines
    # X[, ! (c1 | c2)] <- 0

    ## zero out the parametric cols
    #X[, !grepl('^s\\(', cnames)] <- 0

    ## compute difference
    sm_diff <- drop(X %*% coefs)
    se <- sqrt(rowSums((X %*% V) * X))
    nr <- NROW(X)

    ## Calculate posterior simulation for smooths
    coefs_sim <- t(rmvn(nrep, rep(0, nrow(V)), V))
    rownames(coefs_sim) <- rownames(V)
    simDev <- X %*% coefs_sim
    absDev <- abs(sweep(simDev, 1, se, FUN = "/"))
    masd <- apply(absDev, 2, max)
    crit_s <- quantile(masd, prob = 0.95, type = 8)


    out <- list(smooth = rep(smooth, nr), by = rep(by_var, nr),
                level_1 = rep(f1, nr),
                level_2 = rep(f2, nr),
                diff = sm_diff, se = se,
                lower_s = sm_diff - crit_s * se,
                upper_s = sm_diff + crit_s*se)

    out <- new_tibble(out, nrow = NROW(X), class = "difference_smooth")
    ## Only need rows associated with one of the levels
    out <- bind_cols(out, data[r1, smooth_var])

    out
}
