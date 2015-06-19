library(shiny)
library(lattice)
library(ggplot2)
library(caret)
library(gbm)
library(e1071)

## ICU prediction algorithm
classes <- c("integer","factor","integer",rep("factor",7), rep("integer",2), rep("factor",9))
data <- read.csv("icu.csv", colClasses = classes)
## remove the first column which doesn't contribute to the prediction
data <- data[, -1]

set.seed(2046)
## partition the original training data into a training set (80%) and a validation set (20%)
inTrain <- createDataPartition(y=data$STA, p=0.8, list=FALSE)
training <- data[inTrain,]
validation <- data[-inTrain,]

## training the prediction model using logistic regression
modFit <- glm(STA ~ AGE+CAN+SYS+PRE+TYP+PH+PCO+LOC, family=binomial, data=training)

########################################################################################

shinyServer(
    function(input, output) {
        inputdata <- reactive({ data.frame(
            AGE = input$AGE,
            CAN = input$CAN,
            SYS = input$SYS,
            PRE = input$PRE,
            TYP = input$TYP,
            PH = input$PH,
            PCO = input$PCO,
            LOC = input$LOC
            )
        })
        
        pred <- reactive({predict(modFit, inputdata(), type="response")})
        ## when probability of the prediction is equal or greater than 50%, the status would be "Died"
        result <- reactive({ifelse(pred()[1]>=0.5, "Died","lived")})
        output$prediction <- renderText({
            if (input$goButton == 0)
                return()

            validate(
                need(input$AGE != '' & input$AGE >= 0 & input$AGE <= 120, 'Please enter an age between 0 and 120.'),
                need(!is.na(input$CAN), 'Please select if the patient has cancer.'),
                need(!is.na(input$PRE), 'Please select if the patient was admitted to an ICU within 6 months.'),
                need(!is.na(input$TYP), 'Please select an admission type.'),
                need(!is.na(input$PH), 'Please select a PH level.'),
                need(!is.na(input$PCO), 'Please select a PCO2 level.'),
                need(!is.na(input$LOC), 'Please select the level of patient\'s consciousness.')
            )

            result()
            })
    }
)