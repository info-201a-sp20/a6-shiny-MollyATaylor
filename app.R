library(shiny)
library(ggplot2)
library(dplyr)

avg_state_poverty <- midwest %>%
  group_by(state) %>%
  summarize(adult_poverty = mean(percadultpoverty))

# Define UI for application that draws a histogram
ui <- fluidPage(
              
    # Application title
    titlePanel("Midwest Population Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            poverty_dropdown <- selectInput(
                inputId = "num_hits",
                label = "Select a state", 
                choices = sort(c("ALL", avg_state_poverty$state)),
                selected = "ALL"
            )
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("bar")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$bar <- renderPlot({
        ggplot(avg_state_poverty, aes(x=state, y=adult_poverty)) + 
            geom_bar(stat="identity")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
