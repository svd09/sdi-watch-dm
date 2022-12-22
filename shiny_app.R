# using regular shiny app
# 

library(shiny)
library(tidyverse)
library(bslib)



options_age <- c("< 50","50-54","55-59","60-64","65-69","70-74","75+")
choice_age <- c(0,1,2,3,4,5,6)


options_bmi <- c("< 30","30-34","35-39","40+")
choice_bmi <- c(0,1,3,4)

options_hba1c <- c("< 7","7-8.9","9-9.9","10-11.9","12+")
choice_hba1c <- c(0,1,4,5,6)

options_creat <- c("< 1","1-1.49","1.5+")
choice_creat <- c(0,1,3)

options_sbp <- c("< 100","100-139","140-159","160+")
choice_sbp <- c(0,2,4,5)


options_dbp <- c("< 60","60-79","80+")
choice_dbp <- c(4,2,0)

options_hdlc <- c("< 30","30-59","60+")
choice_hdlc <- c(5,3,0)

options_mi <- c("No","Yes")

options_cabg <- c("No","Yes")


ui <- fluidPage(
    
    titlePanel( "The SDI-WATCH-DM Score"),
    
    fluidRow(
         column(6,
 #   radioButtons(inputId = "options_age",label = "Age (years)",
                 choices = options_age),


    sliderInput(inputId = "options_age", label = "Age(years)",  
                min = 30, max = 90, step = 1,value = 50),                     
    
    radioButtons("options_bmi", "Body mass index (kgm2)",
                 choices = options_bmi),
    
    radioButtons("options_hba1c", label = "HbA1c (%)",
                 choices = options_hba1c))),
    
    fluidRow(
    
    column(6,
    
    radioButtons("options_creat", "Serum Creatinine (mg/dl)",
                 choices = options_creat),
    
    radioButtons("options_sbp", label = "Systolic blood pressure (mmHg)",
                 choices = options_sbp),
    
    radioButtons("options_dbp", "Diastolic blood pressure (mmHg)",
                 choices = options_dbp))),
    
    # column(4,
    # 
    # radioButtons("hdlc", "HDL-C (mg/dl)",
    #              choices = options_hdlc),
    # 
    # 
    # radioButtons("prior_mi", "Prior MI",
    #              choices = options_mi),
    # 
    # radioButtons("prior_cabg", "Prior CABG",
    #              choices = options_cabg))
  
    
    textOutput("value")
    
    
    
    
      )


#get the data from the radio buttons 
#


server <- function(input, output, session){
    
    output$value <- renderText({'input$options_creat'})
    
    
}



shinyApp(ui, server)