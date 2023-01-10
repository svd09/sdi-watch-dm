ui = dashboardPage(
    
    # get the theme         
    
    #        skin = "midnight",
    
    
    # now to insert the action buttons in the side bar...        
    # keep the header title         
    header = dashboardHeader(title = "sdiWATCH-DM Score"),
    
    # now to get the action buttons into the sidebar
    
    sidebar = dashboardSidebar(
        width = 800,
        
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
        
        
        
        tabBox(width = 12,
               tabPanel("Result", width = 12,icon = icon("bar-chart"),
                        
                        
                        # use the box feature to put the map above and then the results
                        
                        box(width = 9,title = "Zip code Map",
                            
                            leafletOutput("zmap"),collapsible = T,solidHeader = T, status = "teal"),
                        
                        box(width = 6, title = "Total WATCH-DM Points",
                            textOutput("sum"), solidHeader = T, status = "primary"),
                        #           box(width = 6, title = "5-year HFH risk category",      
                        #                  textOutput("risk"), solidHeader = T, status = "primary"),
                        box(width = 6, title = "5-year HFH risk: original WATCH-DM Score",      
                            textOutput("orig"), solidHeader = T, status = "primary"),
                        box(width = 6, title = "The SDI quintile according to the Zip code",      
                            textOutput("q2"), solidHeader = T, status = "primary"),
                        box(width = 6, title = "5-year recalibrated HFH risk: sdiWATCH-DM Score",       
                            textOutput("recab2"), solidHeader = T, status = "orange")
               ),
               
               tabPanel("Details", width = 12,icon = icon("circle-info"),
                        
                        box(width = 12, 
                            h6("The WATCH-DM Score is a model to predict the 5-year heart failure hospitalization risk (HFH)
                   in patients with type 2 diabetes mellitus (T2DM). The model contains the following variables; age, body mass index, 
                   blood pressure (systolic & diastolic), 
                   HbA1c level, HDL-C level, serum creatinine, H/O myocardial infarction, and H/O coronary artery bypass grafting. Details regarding the original 
                   WATCH-DM score can be found at: https://pubmed.ncbi.nlm.nih.gov/35656988/. We have recalibrated the score
                   using data from more than 1,000,000 US Veterans receiving outpatient care in the VA healthcare system. We have used their residential zip codes 
                   to determine their social deprivation index (SDI) and present the recalibrated 5-year risk for HFH. The score should not be interpreted as 
                   medical advice. It is to be used by healthcare professionals as an aid for shared clinical decision-making."),
                            tags$html(),
                            h6("The manuscript is currently under review and a link to the original paper will be provided once the paper is accepted for publication.
                   Users that would like to use our code for their own app development can access the folder on github - https://github.com/svd09/sdi-watch-dm-shinyapp
                   or contact the developers listed below." ))))
    )
    ,
    
    
    
    footer = dashboardFooter(left = "Developers: Salil V Deo, Ayush Patel, Sadeer Al-kindi",
                             right = "svd14@case.edu"),
    title = "Contact Details"
)