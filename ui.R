library(shiny)

shinyUI(fluidPage(
    h3("ICU Vital Status Prediction", align = "center"),
    h4("Instructions:"),
    p("This is a Shiny application to predict the vital status of a patient at hospital discharge from ICU."),
    p("The outcome of the prediction is a categorial variable which is either ", strong("'Lived'"), " or ", strong("'Died'"), "."),
    p("To predict a patient's status, you need to enter 8 pieces of information about the patient as below. For 'Age' and 'Systolic bood pressue',
      please enter or select (by sliding) a whole number. All other fields are radio button fields. Once all fields are filled in, you can simply press
      the 'Check Status' button (or let the screen automatically refresh), and the status will show up right next to the 'Patient's Status at hospital discharge'."),
    br(),
    fluidRow(
        column(6,
               numericInput("AGE", "Age (years)", value = NA, min = 0, max = 120, step = 1),
               radioButtons("CAN", "Cancer part of present problem", c("No"=0, "Yes"=1), selected = NULL, inline = TRUE),
               sliderInput('SYS', 'Systolic blood pressure at ICU admission (mm Hg)', min=0, 200, value=0,step=1, round=0),
               radioButtons("PRE", "Previous admission to an ICU within 6 months", c("No"=0, "Yes"=1), selected = NULL, inline = TRUE)
        ),
        column(6,
               radioButtons("TYP", "Type of admission", c("Elective"=0, "Emergency"=1), selected = NULL, inline = TRUE),
               radioButtons("PH", "PH from initial blood gases", c(">= 7.25"=0, "< 7.25"=1), selected = NULL, inline = TRUE),
               radioButtons("PCO", "PCO2 from initial blood gases", c("<= 45"=0, "> 45"=1), selected = NULL, inline = TRUE),
               radioButtons("LOC", "Level of consciousness at ICU admission", c("No coma or deep stupor"=0, "Deep stupor"=1, "Coma"=2), selected = NULL, inline = TRUE)
        )
    ),
    
    br(),
    br(),
    actionButton("goButton", "Check Status"),
    br(),
    br(),
    strong(h4("Patient's Status at hospital discharge:", em(htmlOutput("prediction", inline=TRUE), style = "color: blue")))
))