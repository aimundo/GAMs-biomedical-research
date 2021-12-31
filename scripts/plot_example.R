
## This function plots the rm-ANOVA and LMEM for the data simulated in example.R
plot_example <- function(sim_dat,
                         option="simple") {
    txt<-20

    #plot simulated data (scatterplot)
    p1 <- sim_dat$dat %>%
        ggplot(aes(x = time,
                   y = y,
                   group = treatment,
                   color = treatment)
        ) +
        geom_point(show.legend=FALSE,
                   alpha = 0.5) +
        labs(y='response')+
        geom_line(aes(x = time,
                      y = mu,
                      color = treatment),
                  show.legend=FALSE) +
        theme_classic() +
        theme(plot.title = element_text(size = txt,
                                        face = "bold"),
              text=element_text(size=txt))+
        thm1

    #plot the simulated data with trajectories per each subject
    p2 <- sim_dat$dat %>%
        ggplot(aes(x = time,
                   y = y,
                   group = subject,
                   color = treatment)
        ) +
        geom_line(aes(size = "Subjects"),
                  show.legend = FALSE) +
        # facet_wrap(~ treatment) +
        geom_line(aes(x = time,
                      y = mu,
                      color = treatment,
                      size = "Simulated Truth"),
                  lty = 1,show.legend = FALSE) +
        labs(y='response')+
        scale_size_manual(name = "Type", values=c("Subjects" = 0.5, "Simulated Truth" = 3)) +
        theme_classic()+
        theme(plot.title = element_text(size = txt,
                                        face = "bold"),
              text=element_text(size=txt))+
        thm1

    #plot the errors
    p3 <- sim_dat$dat %>%
        ggplot(aes(x = time,
                   y = errors,
                   group = subject,
                   color = treatment)) +
        geom_line(show.legend=FALSE) +
        labs(y='errors')+
        theme_classic()+
        theme(plot.title = element_text(size = txt,
                                        face = "bold"),
              text=element_text(size=txt))+
        thm1

    #plot the model predictions for rm-ANOVA
    p4 <- ggplot(sim_dat$dat,
                 aes(x = time,
                     y = y,
                     color = treatment)) +
        geom_point(show.legend = FALSE,
                   alpha=0.5)+
        labs(y='response')+
        geom_line(aes(y = predict(sim_dat$fit_anova),
                      group = subject, size = "Subjects"),show.legend = FALSE) +
        geom_line(data = sim_dat$pred_dat,
                  aes(y = predict(sim_dat$fit_anova,
                                  level = 0,
                                  newdata = sim_dat$pred_dat),
                      size = "Population"),
                  show.legend=FALSE) +
        guides(color = guide_legend(override.aes = list(size = 2)))+
        scale_size_manual(name = "Predictions",
                          values=c("Subjects" = 0.5, "Population" = 3)) +
        theme_classic() +
        theme(plot.title = element_text(size = txt,
                                        face = "bold"),
              text=element_text(size=txt))+
        thm1



    #plot the LMEM predictions
    p5 <- ggplot(sim_dat$dat,
                 aes(x = time,
                     y = y,
                     color = treatment)) +
        geom_point(alpha = 0.5)+
        labs(y='response')+
        geom_line(aes(y = predict(sim_dat$fit_lme),
                      group = subject, size = "Subjects")) +
        geom_line(data = sim_dat$pred_dat,
                  aes(y = predict(sim_dat$fit_lme,
                                  level = 0,
                                  newdata = sim_dat$pred_dat),
                      size = "Population")) +
        guides(color = guide_legend(override.aes = list(size = 2)))+
        scale_size_manual(name = "Predictions",
                          values=c("Subjects" = 0.5, "Population" = 3)) +
        theme_classic() +
        theme(plot.title = element_text(size = txt,
                                        face = "bold"),
              text=element_text(size=txt))+
        thm1

    if(option=='simple'){
        return((p1+p4+p5)+plot_layout(nrow=1)+plot_annotation(tag_levels = 'A'))
    }
    else {
    return((p1+p3+p2+p4+p5)+plot_layout(nrow=1)+plot_annotation(tag_levels = 'A'))
    }

}
