library(shiny.semantic)
library(tidyverse)
library(shiny)


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


# reactiveConsole(TRUE)


ui <- semanticPage(
    # title = "The Re-calibrated WATCH-DM score using 
    #               the Social Deprivation Index",
    # h1("SDI-WATCH-DM Score"),
    # h5("This online calculator calculates the risk of the first  
    # heart failure hospitalization for people with type II diabetes mellitus without prior heart failure. 
    # Please select values for your patient using the drop-down options provided below:"),
    # 
    # 
    
    shiny.semantic::sidebar_layout(
    
    shiny.semantic::sidebar_panel(
    
    
    
        cards(
            class = "nine",
            card(
                class = "blue",
                label(class = "header","Age (years)"),
                dropdown_input("options_age",
                             choices =  options_age,
                               value = "50-54",choices_value = choice_age),
                              
            ),
            card(
                class = "blue",
                label(class = "header", "Body mass index (kg/m2)"),
                dropdown_input("options_bmi", choices = options_bmi, 
                               value = "30-34",choices_value = choice_bmi),
            ),
            card(
                class = "blue",
                label(class = "header", "HbA1c (%)"),
                dropdown_input("options_hba1c", choices = options_hba1c,
                               value = "7-8.9",choices_value = choice_hba1c)
                
            ),
            card(
                class = "blue",
                label(class = "header", "HDL-C (d/dl)"),
                dropdown_input("options_hdlc", choices = options_hdlc, 
                               value = "30-59", choices_value = choice_hdlc)
            ),
            card(
                class = "blue",
                label(class = "header","Serum Creatinine (mg/dl)"),
                dropdown_input("options_creat", choices = options_creat, 
                               value = "1-1.49",choices_value = choice_creat)
            ),
            card(class = "blue",
                 label(class = "header","Systolic blood pressure (mmHg)"),
                 dropdown_input("options_sbp", choices = options_sbp, 
                                value = "100-139",choices_value = choice_sbp)
                
            ),
            card(class = "blue",
                 label(class = "header","Diastolic blood pressure (mmHg)"),
                 dropdown_input("options_dbp", choices = options_dbp, 
                                value = "60-79",choices_value = choice_dbp)
            
            
        ),
        card(
            class = "red",
            label(class = "header","Prior MI"),
            dropdown_input("prior_mi", choices = c("No","Yes"),
                           value = "No", choices_value = c(0,1))
            
            
        ),
        
        card(
            class = "red",
            label(class = "header","Prior CABG"),
            dropdown_input("prior_cabg", choices = c("No","Yes"),
                           value = "No", choices_value = c(0,1))
        ),
    cards(
        card(
            class = "green",
            label(class = "header", "Zip code"),
            numeric_input(input_id = "zip_code",label = "5 digit postal Zip Code",value = 44139)
        )
        
    )
        ),
    
    main_panel(
        ,
        card(
            class = "purple",
            label(class = "header", "Total Points"),
            textOutput("total")
        )
    )
    ),
   
    
    
))


# server 

server <- function(input, output){
    
    
}
    
  
#shiny app run 

shinyApp(ui, server)


