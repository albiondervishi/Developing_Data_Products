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
## partition the original training data into a training set (70%) and a validation set (30%)
inTrain <- createDataPartition(y=data$STA, p=0.7, list=FALSE)
training <- data[inTrain,]
validation <- data[-inTrain,]

## Set up 10-fold cross validation in training
ctrl <- trainControl(method="cv", number = 10)

## Boosting
modFit_GBM <- train(STA ~ ., data=training, method="gbm", trControl=ctrl, verbose=FALSE)
########################################################################################

shinyServer(
    function(input, output) {
        inputdata <- reactive({ data.frame(
            AGE = input$AGE,
            SEX = input$SEX,
            RACE = input$RACE,
            SER = input$SER,
            CAN = input$CAN,
            CRN = input$CRN,
            INF = input$INF,
            CPR = input$CPR,
            SYS = input$SYS,
            HRA = input$HRA,
            PRE = input$PRE,
            TYP = input$TYP,
            FRA = input$FRA,
            PO2 = input$PO2,
            PH = input$PH,
            PCO = input$PCO,
            BIC = input$BIC,
            CRE = input$CRE,
            LOC = input$LOC
            )
        })
        
        pred <- reactive({predict(modFit_GBM, inputdata())})
        result <- reactive({ifelse(as.character(pred()[1])=="1", "Died","lived")})
        output$prediction <- renderText({
            if (input$goButton == 0)
                return()

            validate(
                need(input$AGE != '' & input$AGE >= 0 & input$AGE <= 120, 'Please enter an age between 0 and 120.'),
                need(!is.na(input$SEX), 'Please select a gender.'),
                need(!is.na(input$RACE), 'Please select a race.'),
                need(!is.na(input$SER), 'Please select a service type.'),
                need(!is.na(input$CAN), 'Please select if the patient has cancer.'),
                need(!is.na(input$CRN), 'Please select if the patient has ever had chronic renal failure.'),
                need(!is.na(input$INF), 'Please select if there is a probable infection.'),
                need(!is.na(input$PRE), 'Please select if the patient was admitted to an ICU within 6 months.'),
                need(!is.na(input$TYP), 'Please select an admission type.'),
                need(!is.na(input$FRA), 'Please select if the patient has fracture.'),
                need(!is.na(input$PO2), 'Please select a PO2 level.'),
                need(!is.na(input$PH), 'Please select a PH level.'),
                need(!is.na(input$PCO), 'Please select a PCO2 level.'),
                need(!is.na(input$BIC), 'Please select a bicarbonate level.'),
                need(!is.na(input$CRE), 'Please select a creatinine level.'),
                need(!is.na(input$LOC), 'Please select the level of patient\'s consciousness.'),
                need(!is.na(input$CPR), 'Please select if the patient had a CPR prior to admission.')
            )

            result()
            })
    }
)