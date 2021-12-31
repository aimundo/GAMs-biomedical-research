## Example with linear response. This function generates either linear or quadratic mean
#responses with correlated or uncorrelated errors and fits a linear model to the data.

example <- function(n_time = 6, #number of time points
                    fun_type = "linear", #type of response
                    error_type = "correlated") {

    if (!(fun_type %in% c("linear", "quadratic")))
        stop('fun_type must be either "linear", or "quadratic"')
    if (!(error_type %in% c("correlated", "independent")))
        stop('fun_type must be either "correlated", or "independent"')


    x <- seq(1,6, length.out = n_time)

    #Create mean response matrix: linear or quadratic
    mu <- matrix(0, length(x), 2)
    # linear response
    if (fun_type == "linear") {
        mu[, 1] <- - (0.25*x)+2
        mu[, 2] <- 0.25*x+2
    } else {
        # quadratic response (non-linear)

        mu[, 1] <-  -(0.25 * x^2) +1.5*x-1.25
        mu[, 2] <- (0.25 * x^2) -1.5*x+1.25
    }

    #create an array where individual observations per each time point for each group are to be stored. Currently using 10 observations per timepoint
    y <- array(0, dim = c(length(x), 2, 10))

    #Create array to store the "errors" for each group at each timepoint. The "errors" are the
    #between-group variability in the response.
    errors <- array(0, dim = c(length(x), 2, 10))
    #create an array where 10 observations per each time point for each group are to be stored

    #The following cycles create independent or correlated responses. To each value of mu (mean response per group) a randomly generated error (correlated or uncorrelated) is added and thus the individual response is created.
    if (error_type == "independent") {
        ## independent errors
        for (i in 1:2) {
            for (j in 1:10) {
                errors[, i, j] <- rnorm(6, 0, 0.25)
                y[, i, j] <- mu[, i] + errors[, i, j]
            }
        }
    } else {
        for (i in 1:2) {     # number of treatments
            for (j in 1:10) {  # number of subjects
                # compound symmetry errors: variance covariance matrix
                errors[, i, j] <- rmvn(1, rep(0, length(x)), 0.1 * diag(6) + 0.25 * matrix(1, 6, 6))
                y[, i, j] <- mu[, i] + errors[, i, j]
            }
        }
    }


    ## subject random effects

    ## visualizing the difference between independent errors and compound symmetry
    ## why do we need to account for this -- overly confident inference

    #labelling y and errors
    dimnames(y) <- list(time = x,
                        treatment = 1:2,
                        subject = 1:10)

    dimnames(errors) <- list(time = x,
                             treatment = 1:2,
                             subject = 1:10)

    #labeling the mean response
    dimnames(mu) <- list(time = x,
                         treatment = 1:2)

    #convert y, mu and errors to  dataframes with time, treatment and subject columns
    dat <- as.data.frame.table(y,
                               responseName = "y")
    dat_errors <- as.data.frame.table(errors,
                                      responseName = "errors")
    dat_mu <- as.data.frame.table(mu,
                                  responseName = "mu")

    #join the dataframes to show mean response and errors per subject
    dat <- left_join(dat, dat_errors,
                     by = c("time", "treatment", "subject"))
    dat <- left_join(dat, dat_mu,
                     by = c("time", "treatment"))
    #add time
    dat$time <- as.numeric(as.character(dat$time))
    #label subjects per group
    dat <- dat %>%
        mutate(subject = factor(paste(subject,
                                      treatment,
                                      sep = "-")))


    ## repeated measures ANOVA in R
    #time and treatment interaction model
    fit_anova <- lm(y ~ time + treatment + time * treatment, data = dat)


    #LMEM with compound symmetry

    fit_lme <- lme(y ~ treatment + time + treatment:time,
                   data = dat,
                   random = ~ 1 | subject,
                   correlation = corCompSymm(form = ~ 1 | subject)
    )


    #create a prediction frame where the model can be used for plotting purposes
    pred_dat <- expand.grid(
        treatment = factor(1:2),
        time = unique(dat$time)
    )

    #add model predictions to the dataframe that has the simulated data
    dat$pred_anova <- predict(fit_anova)
    dat$pred_lmem <- predict(fit_lme)


    #return everything in a list
    return(list(
        dat = dat,
        pred_dat = pred_dat,
        fit_lme = fit_lme,
        fit_anova=fit_anova

    ))
}
