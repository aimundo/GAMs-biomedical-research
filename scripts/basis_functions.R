#basis functions: this script creates Fig 2. by calculating a GAM for the Group 1 data of Figure 1,
# extracting the basis functions
#and creates objects p11,p12,p13,p14 for plotting, which are combined in b_plot to create the
#final composite figure
n_time = 6
x <- seq(1,6, length.out = n_time)
mu <- matrix(0, length(x), 2)
mu[, 1] <-  -(0.25 * x^2) +1.5*x-1.25 #mean response
mu[, 2] <- (0.25 * x^2) -1.5*x+1.25 #mean response
y <- array(0, dim = c(length(x), 2, 10))
errors <- array(0, dim = c(length(x), 2, 10))
for (i in 1:2) {     # number of treatments
    for (j in 1:10) {  # number of subjects
        # compound symmetry errors
        errors[, i, j] <- rmvn(1, rep(0, length(x)), 0.1 * diag(6) + 0.25 * matrix(1, 6, 6))
        y[, i, j] <- mu[, i] + errors[, i, j]
    }
}

#label each table
dimnames(y) <- list(time = x, treatment = 1:2, subject = 1:10)
dimnames(errors) <- list(time = x, treatment = 1:2, subject = 1:10)
dimnames(mu) <- list(time = x, treatment = 1:2)

#Convert to dataframes with subject, time and group columns
dat <- as.data.frame.table(y, responseName = "y")
dat_errors <- as.data.frame.table(errors, responseName = "errors")
dat_mu <- as.data.frame.table(mu, responseName = "mu")
dat <- left_join(dat, dat_errors, by = c("time", "treatment", "subject"))
dat <- left_join(dat, dat_mu, by = c("time", "treatment"))
dat$time <- as.numeric(as.character(dat$time))

#label subject per group
dat <- dat %>%
    mutate(subject = factor(paste(subject, treatment, sep = "-")))

#extract  "Group 1" to fit the GAM
dat<-subset(dat,treatment==1)
#keep just the response and timepoint columns
dat<-dat[,c('y','time')]

#GAM model of time, 5 basis functions
gm<-gam(y~s(time,k=5),data=dat, method= "REML")

#model_matrix (also known as) 'design matrix'
#will contain the smooths used to create  model 'gm'
model_matrix<-as.data.frame(predict(gm,type='lpmatrix'))


time<-c(1:6)

basis<-model_matrix[1:6,] #extracting basis (because the values are repeated after every 6 rows)
#basis<-model_matrix[1:6,-1] #extracting basis
colnames(basis)[colnames(basis)=="(Intercept)"]<-"s(time).0"
basis<-basis %>% #pivoting to long format
    pivot_longer(
        cols=starts_with("s")
    )%>%
    arrange(name) #ordering

#length of dataframe to be created: number of basis by number of timepoints (minus 1 for the intercept that we won't plot)
ln<-6*(length(coef(gm)))

basis_plot<-data.frame(Basis=integer(ln),
                       value_orig=double(ln),
                       time=integer(ln),
                       cof=double(ln)
)

basis_plot$time<-rep(time) #pasting timepoints
basis_plot$Basis<-factor(rep(c(1:5),each=6)) #pasting basis number values
basis_plot$value_orig<-basis$value #pasting basis values
basis_plot$cof<-rep(coef(gm)[1:5],each=6) #pasting coefficients
basis_plot<-basis_plot%>%
    mutate(mod_val=value_orig*cof) #the create the predicted values the bases need to be
#multiplied by the coefficients

#creating labeller to change the labels in the basis plots

basis_names<-c(
    `1`="Intercept",
    `2`="1",
    `3`="2",
    `4`="3",
    `5`="4"
)

#calculating the final smooth by aggregating the basis functions

smooth<-basis_plot%>%
    group_by(time)%>%
    summarize(smooth=sum(mod_val))


#original basis
sz<-1
p11<-ggplot(basis_plot,
            aes(x=time,
                y=value_orig,
                colour=as.factor(Basis)
            )
)+
    geom_line(size=sz,
              show.legend=FALSE)+
    geom_point(size=sz+1,
               show.legend = FALSE)+
    labs(y='Basis functions')+
    facet_wrap(~Basis,
               labeller = as_labeller(basis_names)
    )+
    theme_classic()+
    thm1


#penalized basis
p12<-ggplot(basis_plot,
            aes(x=time,
                y=mod_val,
                colour=as.factor(Basis)
            )
)+
    geom_line(show.legend = FALSE,
              size=sz)+
    geom_point(show.legend = FALSE,
               size=sz+1)+
    labs(y='Penalized \n basis functions')+
    scale_y_continuous(breaks=seq(-1,1,1))+
    facet_wrap(~Basis,
               labeller=as_labeller(basis_names)
    )+
    theme_classic()+
    thm1

#heatmap of the  coefficients
x_labels<-c("Intercept","1","2","3","4")
p13<-ggplot(basis_plot,
            aes(x=Basis,
                y=Basis))+
    geom_tile(aes(fill = cof),
              colour = "black") +
    scale_fill_gradient(low = "white",
                        high = "#B50A2AFF")+
    labs(x='Basis',
         y='Basis')+
    scale_x_discrete(labels=x_labels)+
    geom_text(aes(label=round(cof,2)),
              size=7,
              show.legend = FALSE)+
    theme_classic()+
    theme(legend.title = element_blank())

#plotting simulated datapoints and smooth term
p14<-ggplot(data=dat,
            aes(x=time,y=y))+
    geom_point(size=sz+1,alpha=0.5)+
    thm1+
    labs(y='Simulated \n response')+
    geom_line(data=smooth,
              aes(x=time,
                  y=smooth),
              color="#6C581DFF",
              size=sz+1)+
    theme_classic()


#Combining all
b_plot<-p11+p13+p12+p14+plot_annotation(tag_levels='A')&
    theme(
        text=element_text(size=18)
    )

