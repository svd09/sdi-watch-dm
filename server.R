
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

