library(shiny)

shinyUI(fluidPage(
  titlePanel("Basic Value-At-Risk (VAR) Model"),
  
  sidebarLayout(
    sidebarPanel(
        
      radioButtons("radio",label="Select Source of Financial data",
                   c("Yahoo Finance"="yahoo","Google Finance"="google"),selected="yahoo"),
                   
             textInput("symb1", "Select 1st Stock using its Stock Symbol", "CSCO"),
      br(),
        
      dateRangeInput("dates", 
        "Select Period for VAR Analysis",
        start = "2014-01-01", 
        end = as.character(Sys.Date())),
      
      radioButtons("VARConfInt",label="Select VAR Confidence Interval",
                   c("90%"=0.1,"95%"=0.05,"99%"=0.01,"99.9%"=0.001),selected="95%"),
   
      actionButton("get", "Analyze"),
      
      br(),
      br()
      
      ),
      
    
    mainPanel(
      conditionalPanel(
        condition="input.get!='None'",
        tabsetPanel(
          
          tabPanel("VAR Model",
                   helpText("Below plot shows the distribution of the returns"),
                   helpText("In the same plot we have also shown, the chosen stock's VAR value in red 
                            and S&P500 VAR value in green, for the same period"),
                   plotOutput("varplot"),
                   tableOutput("VARData")
                  )
                                
               ))
  ))
))