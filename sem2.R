# test app using shiny.semantic
# 

library(shiny.semantic)
library(tidyverse)
library(shiny)

# getting all the options for the variables 
# list them all

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


load('d_zipcodes.rda')


ui <- semanticPage(
     titlePanel("The sdiWATCH-DM score"),
     
     
    
     h5("This online calculator calculates the risk of the first  
     heart failure hospitalization for people with type II diabetes mellitus without prior heart failure. 
     Please select values for your patient using the drop-down options provided below:"),
    
    shiny.semantic::sidebar_layout(
        shiny.semantic::sidebar_panel(
            
            
            
            cards(
                
                card(width = 6,
                    class = "blue",
                    label(class = "header","Age (years)"),
                    dropdown_input("options_age",
                                   choices =  options_age,
                                   value = "50-54",choices_value = choice_age)),
                    
                    card(width = 6,class = "blue",
                        label(class = "header", "Body mass index (kg/m2)"),
                        dropdown_input("options_bmi", choices = options_bmi, 
                                       value = "30-34",choices_value = choice_bmi)),
                    card(width = 6,
                        class = "blue",
                        label(class = "header", "HbA1c (%)"),
                        dropdown_input("options_hba1c", choices = options_hba1c,
                                       value = "7-8.9",choices_value = choice_hba1c)),
                    card(width = 6,
                        class = "blue",
                        label(class = "header", "HDL-C (d/dl)"),
                        dropdown_input("options_hdlc", choices = options_hdlc, 
                                       value = "30-59", choices_value = choice_hdlc)),
                    card(
                        class = "blue",
                        label(class = "header","Serum Creatinine (mg/dl)"),
                        dropdown_input("options_creat", choices = options_creat, 
                                       value = "1-1.49",choices_value = choice_creat)),
                    card(class = "blue",
                         label(class = "header","Systolic blood pressure (mmHg)"),
                         dropdown_input("options_sbp", choices = options_sbp, 
                                        value = "100-139",choices_value = choice_sbp)),
                    card(class = "blue",
                         label(class = "header","Diastolic blood pressure (mmHg)"),
                         dropdown_input("options_dbp", choices = options_dbp, 
                                        value = "60-79",choices_value = choice_dbp)),
                    card(class = "red",
                        label(class = "header","Prior MI"),
                        dropdown_input("prior_mi", choices = c("No","Yes"),
                                       value = "No", choices_value = c(0,3))),
                    
                    card(class = "red",
                        label(class = "header","Prior CABG"),
                        dropdown_input("prior_cabg", choices = c("No","Yes"),
                                       value = "No", choices_value = c(0,3))),
                    card(class = "green",
                            label(class = "header", "Zip code"),            
                         dropdown_input(
                                "options_zip",
                                "5-digit Zip code",
                                choices = d$ZIP,
                                choices_value = d$ZIP[1]
                                ))
                        )),
        
        main_panel(
            
            actionButton("score", "Get Risk")
        ,
                
            textOutput("total"),
        
        textOutput("risk"))))
    
    
        
    

server <- function(input,output){
    
    observeEvent(input$score, {
            age <- input[['options_age']] %>% as.numeric()
            
            bmi <- input[['options_bmi']] %>% as.numeric()
            
            hba1c <- input[['options_hba1c']] %>% as.numeric()
            
            hdlc <- input[['options_hdlc']] %>% as.numeric()
            
            sbp <- input[['options_sbp']] %>% as.numeric()
            
            dbp <- input[['options_dbp']] %>% as.numeric()
            
            prior_mi <- input[['prior_mi']] %>% as.numeric()
            
    
            prior_cabg <- input[['prior_cabg']]  %>% as.numeric()
            
        n <- sum(age,bmi, hba1c, hdlc, sbp, dbp, 
                prior_mi, prior_cabg)    
            
    
            
    output$total <- 
        renderText(paste(
        "The total WATCH-DM points are:",
        n)) 
    
    })
    

    # get the risk groups 
    # 
    
     g <- reactive({ifelse(
         n< 11,"Very Low",
         ifelse(
             n %in% c(12,13), "Low",
             ifelse(
                 n %in% c(14,15), "Moderate",
                 ifelse(
                    n %in% c(16,17,18), "High", "Very High"
                 )
             )
         )
     )
     }) 
     

     
    #output$risk <- 
    #    renderText(paste("The WATCH-DM Score category is:", g))
  
    output$risk <- renderText(g)
    # 
    # # baseline survival 
    # # 
    # 
    # S0t = 0.9934
    # 
    # beta = 0.118668
    # 
    # orig <- 1 - S0t**exp(n*beta)
    # 
    # orig2 <- orig*100
    # 
    # #output$orig <- renderText(paste("The 5-year WATCH-DM heart failure hospitalization predicted risk is", paste0(round(orig2,2),"%",sep =" ")))
    # output$orig <- renderText(paste0(round(orig2,2),"%",sep =" "))
    # 
    # 
    # 
    # # get the quintile for the risk using the zip code data 
    # 
    # #        d <- read_csv("map_data.csv")
    # 
    # t <- reactive({
    #     d %>% filter(ZIP %in% input$options_zip)
    # })
    # 
    # quintile <- t()$quintile
    # 
    # #output$q2 <- renderText(paste("Your SDI is in the quintile",t()$quintile))
    # output$q2 <- renderText(t()$quintile)
    # 
    # 
    # log_eo <- ifelse(
    #     quintile == 1, 0.3160,
    #     ifelse(
    #         quintile == 2, 0.1508,
    #         ifelse(
    #             quintile == 3, 0.0268,
    #             ifelse(
    #                 quintile == 4, -0.0545, -0.2260
    #             )
    #         )
    #     )
    # )
    # 
    # recab <- (1 - S0t**exp(n*beta - log_eo))*100
    # 
    # #output$recab2 <- 
    # #    renderText(paste("The sdiWATCH-DM recalibrated heart failure hospitalization risk is", 
    # #                     paste0(round(recab,2),"%", sep = " "))) 
    # 
    # 
    # output$recab2 <- 
    #     renderText(paste0(round(recab,2),"%", sep = " ")) 
    # 
    # 
    # # map 
    # 
    # output$zmap <- renderLeaflet({
    #     leaflet() %>% addTiles() %>% 
    #         addMarkers(lng = t()$lng,lat = t()$lat, label = "Mapped Zip code")
    # })    
    # 
    # 
    
    
    
    
}
   

shinyApp(ui, server)