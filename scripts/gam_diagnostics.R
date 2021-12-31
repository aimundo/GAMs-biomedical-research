#Function that uses the source code of `gam.check` to obtain the estimates without the plots. The source can be checked by typing `gam.check` in the console.
gam_diagnostics<-function (b, old.style = FALSE, type = c("deviance", "pearson",
                                                          "response"), k.sample = 5000, k.rep = 200, rep = 0,
                           level = 0.9, rl.col = 2, rep.col = "gray80", ...)
{
    type <- match.arg(type)
    resid <- residuals(b, type = type)
    linpred <- if (is.matrix(b$linear.predictors) && !is.matrix(resid))
        napredict(b$na.action, b$linear.predictors[, 1])
    else napredict(b$na.action, b$linear.predictors)

    fv <- if (inherits(b$family, "extended.family"))
        predict(b, type = "response")
    else fitted(b)
    if (is.matrix(fv) && !is.matrix(b$y))
        fv <- fv[, 1]
    gamm <- !(b$method %in% c("GCV", "GACV", "UBRE",
                              "REML", "ML", "P-ML", "P-REML",
                              "fREML"))
    if (gamm) {
        cat("\n'gamm' based fit - care required with interpretation.")
        cat("\nChecks based on working residuals may be misleading.")
    }
    else {
        cat("\nMethod:", b$method, "  Optimizer:",
            b$optimizer)
        if (!is.null(b$outer.info)) {
            if (b$optimizer[2] %in% c("newton", "bfgs")) {
                boi <- b$outer.info
                cat("\n", boi$conv, " after ", boi$iter,
                    " iteration", sep = "")
                if (boi$iter == 1)
                    cat(".")
                else cat("s.")
                cat("\nGradient range [", min(boi$grad),
                    ",", max(boi$grad), "]", sep = "")
                cat("\n(score ", b$gcv.ubre, " & scale ",
                    b$sig2, ").", sep = "")
                ev <- eigen(boi$hess)$values
                if (min(ev) > 0)
                    cat("\nHessian positive definite, ")
                else cat("\n")
                cat("eigenvalue range [", min(ev), ",",
                    max(ev), "].\n", sep = "")
            }
            else {
                cat("\n")
                print(b$outer.info)
            }
        }
        else {
            if (length(b$sp) == 0)
                cat("\nModel required no smoothing parameter selection")
            else {
                cat("\nSmoothing parameter selection converged after",
                    b$mgcv.conv$iter, "iteration")
                if (b$mgcv.conv$iter > 1)
                    cat("s")
                if (!b$mgcv.conv$fully.converged)
                    cat(" by steepest\ndescent step failure.\n")
                else cat(".\n")
                cat("The RMS", b$method, "score gradient at convergence was",
                    b$mgcv.conv$rms.grad, ".\n")
                if (b$mgcv.conv$hess.pos.def)
                    cat("The Hessian was positive definite.\n")
                else cat("The Hessian was not positive definite.\n")
            }
        }
        if (!is.null(b$rank)) {
            cat("Model rank = ", b$rank, "/", length(b$coefficients),
                "\n")
        }
    }
    cat("\n")
    kchck <- k.check(b, subsample = k.sample, n.rep = k.rep)
    if (!is.null(kchck)) {
        cat("Basis dimension (k) checking results. Low p-value (k-index<1) may\n")
        cat("indicate that k is too low, especially if edf is close to k'.\n\n")
        printCoefmat(kchck, digits = 3)
    }
}
