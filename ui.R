library(shiny)

shinyUI(fluidPage(
    h3("ICU Vital Status Prediction", align = "center"),
    h4("Instructions:"),
    p("This is a Shiny application to predict the vital status of a patient at hospital discharge from ICU."),
    p("The outcome of the prediction is a categorial variable which is either ", strong("'Lived'"), " or ", strong("'Died'"), "."),
    p("To predict the patient's status, you need to enter 19 pieces of information about the patient as below. For 'Age', 'Systolic bood pressue' and 
     'Heart Rate', please enter or select (by sliding) a whole number. All other fields are radio button fields. Once all fields are filled in, you can simply press
      the 'Check Status' butto, and the status will show up right next to the 'Status at hospital discharge'."),
    br(),
    fluidRow(
        column(4,
               numericInput("AGE", "Age (years)", value = NA, min = 0, max = 120, step = 1),
               radioButtons("SEX", "Gender", c("Male"=0, "Female"=1), selected = NULL, inline = TRUE),
               radioButtons("RACE", "Race", c("White"=1, "Black"=2, "Other"=3), selected = NULL, inline = TRUE),
               radioButtons("SER", "Service at ICU admission", c("Male"=0, "Female"=1), selected = NULL, inline = TRUE),
               radioButtons("CAN", "Cancer part of present problem", c("No"=0, "Yes"=1), selected = NULL, inline = TRUE),
               radioButtons("CRN", "History of chronic renal failure", c("No"=0, "Yes"=1), selected = NULL, inline = TRUE),
               radioButtons("INF", "Infection probable at ICU admission", c("No"=0, "Yes"=1), selected = NULL, inline = TRUE)
        ),
        column(4,
               sliderInput('SYS', 'Systolic blood pressure at ICU admission (mm Hg)', min=0, 200, value=0,step=1, round=0),
               sliderInput('HRA', 'Heart rate at ICU admission (beats/min)', min=0, 150, value=0,step=1, round=0),
               radioButtons("PRE", "Previous admission to an ICU within 6 months", c("No"=0, "Yes"=1), selected = NULL, inline = TRUE),
               radioButtons("TYP", "Type of admission", c("Elective"=0, "Emergency"=1), selected = NULL, inline = TRUE),
               radioButtons("FRA", "Long bone, multiple, neck, single area, or hip fracture", c("No"=0, "Yes"=1), selected = NULL, inline = TRUE)
        ),
        column(4,
               radioButtons("PO2", "PO2 from initial blood gases", c("> 60"=0, "<= 60"=1), selected = NULL, inline = TRUE),
               radioButtons("PH", "PH from initial blood gases", c(">= 7.25"=0, "< 7.25"=1), selected = NULL, inline = TRUE),
               radioButtons("PCO", "PCO2 from initial blood gases", c("<= 45"=0, "> 45"=1), selected = NULL, inline = TRUE),
               radioButtons("BIC", "Bicarbonate from initial blood gases", c(">= 18"=0, "< 18"=1), selected = NULL, inline = TRUE),
               radioButtons("CRE", "Creatinine from initial blood gases", c("<= 2.0"=0, "> 2.0"=1), selected = NULL, inline = TRUE),
               radioButtons("LOC", "Level of consciousness at ICU admission", c("No coma or deep stupor"=0, "Deep stupor"=1, "Coma"=2), selected = NULL, inline = TRUE),
               radioButtons("CPR", "CPR prior to ICU admission", c("No"=0, "Yes"=1), selected = NULL, inline = TRUE)
        )
    ),
    
    br(),
    br(),
    actionButton("goButton", "Check Status"),
    br(),
    br(),
    strong(h4("Patient's Status at hospital discharge:", em(htmlOutput("prediction", inline=TRUE), style = "color: blue")))
))