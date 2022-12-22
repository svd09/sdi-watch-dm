# script for the UI for the SDI recalibrated WATCH-DM score
# using shiny fluent for developing the UI
# 
#

library(shiny)
library(shiny.fluent)
library(shiny.react)
library(tidyverse)
library(glue)




makeCard <- function(title, content, size = 12, style = "") {
    div(
        class = glue("card ms-depth-8 ms-sm{size} ms-xl{size}"),
        style = style,
        Stack(
            tokens = list(childrenGap = 5),
            Text(variant = "large", title, block = TRUE),
            content
        )
    )
}

# get the input options for the drop down menu

options_age <- list(
        list(key = 0, text = "< 50"),
        list(key = 1, text = "50 - 54"),
        list(key = 2, text = "55 - 59"),
        list(key = 3, text = "60 - 64"),
        list(key = 4, text = "65 - 69"),
        list(key = 5, text = "70 - 74"),
        list(key = 6, text = "75+")
        )
    
    
options_bmi <- list(
    list(key = 0, text = "< 30"),
    list(key = 1, text = "30 - 34"),
    list(key = 3, text = "35 - 39"),
    list(key = 4, text = "40+")
)



ui = fluentPage(
    
    Stack(Text(variant = "xLarge", "The Re-calibrated WATCH-DM score using 
                  the Social Deprivation Index"), center = T),
              
        Text(variant = "medium", "This online calculator provides the risk for 
                  heart failure hospitalization for people with type II diabetes mellitus."))
    
    
    
    Stack(
        
        tags$style(".card{padding: 28px; margin-bottom: 28px;}"), 
        
        makeCard(Dropdown.shinyInput("dropdown", value = 0, options = options_age,  label = "Age (Years)"),
    textOutput("dropdownValue")),
    
    makeCard(Dropdown.shinyInput("dropdown", value = 0, options = options_bmi,  label = "Body mass index (kg/m2)"),
    textOutput("dropdownValue")), vertical = T)
        
        
        server = function(input, output) {
            output$dropdownValue <- renderText({
                sprintf("Points: %s", input$dropdown)
            })
            
            output$dropdownValue <- renderText({
                sprintf("Points: %s", input$dropdown)
            })
        }


shinyApp(ui, server)