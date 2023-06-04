library(googledrive)
library(googlesheets4) # I am using the developing version 0.1.0.9000
library(shiny)
library(shinydashboard)
library(tidyverse)
library(readxl)



ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    
    fluidRow(
      tabBox(
        title = "First tabBox",
        # The id lets us use input$tabset1 on the server to find the current tab
        id = "tabset1", width=12,
        tabPanel("TOUCHSTONE", 
                 uiOutput("touchstone"),
                 actionButton("newtouchstone", "DRAW")),
        tabPanel("WORKSHOP", 
                 uiOutput("workshop"),
                 actionButton("newworkshop", "DRAW")),
      #  tabPanel("WORKSHOP", uiOutput("workshop")),
       # tabPanel("TOOL", uiOutput("tool")),
        #tabPanel("PROTOCOL", uiOutput("protocol")),
        #tabPanel("PLATFORM", uiOutput("platform")),
      ),
  ),
),
)

server <- function(input, output) { 
  
  #update_data <- reactive({
  entries <- read_sheet("https://docs.google.com/spreadsheets/d/13ZuEqXz3gGgovGVP-714SsFIYh0He_e-jSVIg82A-zU/edit?usp=sharing")
  
  touchstones <- filter(entries, Category2 == 'Touchstone')
  workshops <- filter(entries, Category2 == 'Workshop')
  tools <- filter(entries, Category2 == 'Tool')
  protocols <- filter(entries, Category2 == 'Protocol')
  platforms <- filter(entries, Category2 == 'Platform')
#})
  
  drawtouchstone <- eventReactive(input$newtouchstone,{
    entries[sample(which(entries$Category2 == 'Touchstone'), 1),]
  })
  output$touchstone <- renderUI({
    x <- drawtouchstone()
    x$Name
    x$Text
  })
  
  drawworkshop <- eventReactive(input$newworkshop,{
    entries[sample(which(entries$Category2 == 'Workshop'), 1),]
  })
  output$workshop <- renderUI({
    x <- drawworkshop()
    tagList(h1(x$Name),
            p(x$Text))
  })

}
entries <- read_xlsx('entries.xlsx')



gs4_deauth()
webentries <- (read_sheet("https://docs.google.com/spreadsheets/d/13ZuEqXz3gGgovGVP-714SsFIYh0He_e-jSVIg82A-zU/edit?usp=sharing"))

shinyApp(ui, server)
