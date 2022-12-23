library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(leaflet)
library(tidyverse)


load('d_zipcodes.rda')

shinyApp(
    ui = dashboardPage(
        
# get the theme         
        
#        skin = "midnight",
        
        
# now to insert the action buttons in the side bar...        
# keep the header title         
    header = dashboardHeader(title = "sdiWATCH-DM Score"),

# now to get the action buttons into the sidebar

        sidebar = dashboardSidebar(
            
            
            sliderInput(
                inputId = "options_age", label = "Age(years)",
                min = 30, max = 90, step = 1, value = 50
            ),
            # bmi
            sliderInput(
                inputId = "options_bmi", label = "Body mass index (kg/m2)",
                min = 20, max = 55, value = 30, step = 1
            ),
            # hba1c
            sliderInput("options_hba1c", "HbA1c(%)", min = 5, max = 15, step = 0.1, value = 7)
            ,
            # zip code
            
            pickerInput(
                inputId = "options_zip",
                label = "5-digit Zip code",
                choices = d$ZIP,
                selected = d$ZIP[1],
                multiple = F,
                options = list(
                    `live-search` = TRUE)),
            shiny::tags$hr(),
            # creatinine
            sliderInput("options_creat", "Creatinine(mg/dl)", min = 0.5, max = 5, step = 0.1, value = 1),
            
            # sbp
            sliderInput("options_sbp", "Systolic blood pressure(mmHg)", min = 70, max = 200, step = 1, value = 120),
            
            # dbp
            sliderInput("options_dbp", "Diastolic blood pressure(mmHg)", min = 50, max = 120, step = 1, value = 80),
            shiny::tags$hr(),
            # hdlc
            sliderInput("options_hdlc", "HDL-C(mg/dl)", min = 20, max = 80, step = 1, value = 40),
            
            # mi
            prettyRadioButtons("options_mi", "Prior MI", choices = c("No", "Yes")),
            
            # cabg
            prettyRadioButtons("options_cabg", "Prior CABG", choices = c("No", "Yes")),
            
            # get risk
            actionButton("score", "Get Risk")
            ),

# insert the map and the estimated risk i.e. the results in the body 
        body = dashboardBody(
            
# use the box feature to put the map above and then the results
            
            box(width = 9,title = "Zip code Map",
                   
            leafletOutput("zmap"),collapsible = T),
            
            box(width = 6, title = "Total WATCH-DM Points",
                   textOutput("sum")),
            box(width = 6, title = "5-year HFH risk category",      
                   textOutput("risk")),
            box(width = 6, title = "5-year HFH risk: original WATCH-DM Score",      
                   textOutput("orig")),
            box(width = 6, title = "The SDI quintile according to the Zip code",      
                   textOutput("q2")),
            box(width = 6, title = "5-year recalibrated HFH risk: sdiWATCH-DM Score",       
                   textOutput("recab2"))
      )
        ,
        
        
        
        footer = dashboardFooter(left = "Developers: Salil V Deo, Ayush Patel, Sadeer Al-kindi",
                                 right = "svd14@case.edu"),
        title = "Contact Details"
    ),


server = function(input, output, session) { 
        observeEvent(input$score, {
            # age
            
            age <-
                ifelse(input$options_age < 50, 0,
                       ifelse(
                           input$options_age >= 50 & input$options_age < 55, 1,
                           ifelse(
                               input$options_age >= 55 & input$options_age < 60, 2,
                               ifelse(
                                   input$options_age >= 60 & input$options_age < 65, 3,
                                   ifelse(
                                       input$options_age >= 65 & input$options_age < 70, 4,
                                       ifelse(
                                           input$options_age >= 70 & input$options_age < 75, 5, 6
                                       )
                                   )
                               )
                           )
                       )
                )
            
            # bmi
            
            bmi <- ifelse(input$options_bmi < 30, 0,
                          ifelse(
                              input$options_bmi >= 30 & input$options_bmi < 35, 1,
                              ifelse(
                                  input$options_bmi >= 35 & input$options_bmi < 40, 3, 4
                              )
                          )
            )
            
            
            # hba1c
            
            hba1c <- ifelse(input$options_hba1c < 7, 0,
                            ifelse(
                                input$options_hba1c >= 7 & input$options_hba1c < 9, 1,
                                ifelse(
                                    input$options_hba1c >= 9 & input$options_hba1c < 9.9, 4,
                                    ifelse(
                                        input$options_hba1c >= 10 & input$options_hba1c < 11.9, 5, 6
                                    )
                                )
                            )
            )
            
            
            # hdlc
            
            hdlc <- ifelse(input$options_hdlc < 30, 5,
                           ifelse(
                               input$options_hdlc >= 30 & input$options_hdlc < 35, 1,
                               ifelse(
                                   input$options_hdlc >= 35 & input$options_hdlc < 40, 3, 4
                               )
                           )
            )
            
            
            # sbp
            #
            
            sbp <- ifelse(input$options_sbp < 100, 0,
                          ifelse(
                              input$options_sbp >= 100 & input$options_sbp < 140, 2,
                              ifelse(
                                  input$options_sbp >= 140 & input$options_sbp < 160, 4, 5
                              )
                          )
            )
            
            # dbp
            #
            
            dbp <- ifelse(input$options_dbp < 60, 4,
                          ifelse(
                              input$options_dbp >= 60 & input$options_sbp < 79, 2, 0
                          )
            )
            
            
            # prior mi 
            # 
            
            prior_mi <- ifelse(
                input$options_mi == "No",0,3
            )
            
            prior_cabg <- ifelse(
                input$options_cabg == "No",0,3
            )

            n <- age + bmi + hdlc + hba1c + sbp + dbp + prior_mi + prior_cabg
            
            #output$sum <- renderText(paste("The WATCH-DM Score is", n))
            output$sum <- renderText(n)
            
            # get the risk groups 
            # 
            
            g <- ifelse(
                n < 11,"Very Low",
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
            
            #output$risk <- renderText(paste("The WATCH-DM Score category is", g))    
            output$risk <- renderText(g)
            
            # baseline survival 
            # 
            
            S0t = 0.9934
            
            beta = 0.118668
            
            orig <- 1 - S0t**exp(n*beta)
            
            orig2 <- orig*100
            
            #output$orig <- renderText(paste("The 5-year WATCH-DM heart failure hospitalization predicted risk is", paste0(round(orig2,2),"%",sep =" ")))
            output$orig <- renderText(paste0(round(orig2,2),"%",sep =" "))
            
            
            
            # get the quintile for the risk using the zip code data 
            
            #        d <- read_csv("map_data.csv")
            
            t <- reactive({
                d %>% filter(ZIP %in% input$options_zip)
            })
            
            quintile <- t()$quintile
            
            #output$q2 <- renderText(paste("Your SDI is in the quintile",t()$quintile))
            output$q2 <- renderText(t()$quintile)
            
            
            log_eo <- ifelse(
                quintile == 1, 0.3160,
                ifelse(
                    quintile == 2, 0.1508,
                    ifelse(
                        quintile == 3, 0.0268,
                        ifelse(
                            quintile == 4, -0.0545, -0.2260
                        )
                    )
                )
            )
            
            recab <- (1 - S0t**exp(n*beta - log_eo))*100
            
            #output$recab2 <- 
            #    renderText(paste("The sdiWATCH-DM recalibrated heart failure hospitalization risk is", 
            #                     paste0(round(recab,2),"%", sep = " "))) 
            
            
            output$recab2 <- 
                renderText(paste0(round(recab,2),"%", sep = " ")) 
            
            
            # map 
            
            output$zmap <- renderLeaflet({
                leaflet() %>% addTiles() %>% 
                    addMarkers(lng = t()$lng,lat = t()$lat, label = "Mapped Zip code")
            })    
            
            
            
        })
    }
)

