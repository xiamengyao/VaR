# server.R

#Date 24th  Feb 2015 

library(quantmod)


shinyServer(function(input, output) {
 
    stckfulldata<-reactive({
      if(input$get==0)return(NULL)
      isolate({    
    getSymbols(input$symb1,src=input$radio,
               from=input$dates[1],
               to=input$dates[2],auto.assign=FALSE)
  })
    })
  
  
  output$varplot<-renderPlot({
    if(input$get==0)return(NULL)
   stckclosedata<-stckfulldata()[,4]
   cont_returns<-diff(log(stckclosedata))*100
   VARCI<-as.numeric(input$VARConfInt)
   varpoint<-quantile(cont_returns,probs=VARCI,na.rm=TRUE)
   
   SP500closedata<-SP500()[,4]
   SP500cont_returns<-diff(log(SP500closedata))*100
   SP500var<-quantile(SP500cont_returns,probs=VARCI,na.rm=TRUE)
   colname1<-paste("VAR of",input$symb1)
     
   
   plot(cont_returns,xlab="Period",ylab="Daily % Returns",main=paste("Plot showing Daily % returns for",input$symb1)) 
   #dnorm(cont_returns,mean=0,sd=1)
   abline(h=varpoint,col="red",lwd=2,label="VAR")
   text(0,-10, colname1, col = "red")
   abline(h=SP500var,col="green",lwd=2)
   text(0,-20, "VAR of S&P500", col = "green")
     })
  
  output$VARData<-renderTable({
    if(input$get==0)return(NULL)
    stckclosedata<-stckfulldata()[,4]
    cont_returns<-diff(log(stckclosedata))*100
    VARCI<-as.numeric(input$VARConfInt)
    varpoint<-quantile(cont_returns,probs=VARCI,na.rm=TRUE)
    SP500closedata<-SP500()[,4]
    SP500cont_returns<-diff(log(SP500closedata))*100
    SP500var<-quantile(SP500cont_returns,probs=VARCI,na.rm=TRUE)
    newmat<-matrix(nrow=1,ncol=2)
    newmat[1,1]<-varpoint
    newmat[1,2]<-SP500var
    #colname1<-paste("VAR of",input$symb1)
    colnames(newmat)<-c(paste("VAR of",input$symb1),"VAR of S&P500")
    newmat
  })
  
  
  
  
  SP500<-reactive({
    if(input$get==0)return(NULL)
    isolate({    
      getSymbols("SPY",src=input$radio,
                 from=input$dates[1],
                 to=input$dates[2],auto.assign=FALSE)
    })
  })
})