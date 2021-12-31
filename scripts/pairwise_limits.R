#function to obtain values for the shading regions of the pairwise comparison between the smooths

pairwise_limits<-function(dataframe){
    #extract values where the lower limit of the ribbon is greater than zero
    #this is the region where the control group effect is greater

    v1<-dataframe%>%
        filter(lower_s>0)%>%
        select(Day)
    #get day  initial value
    init1=v1$Day[[1]]
    #get day final value
    final1=v1$Day[[nrow(v1)]]
    #extract values where the value of the upper limit of the ribbon is lower than zero
    #this corresponds to the region where the treatment group effect is greater
    v2<-dataframe%>%
        filter(upper_s<0)%>%
        select(Day)

    init2=v2$Day[[1]]
    final2=v2$Day[[nrow(v2)]]
    #store values
    my_list<-list(init1=init1,
                  final1=final1,
                  init2=init2,
                  final2=final2)
    return(my_list)



}
