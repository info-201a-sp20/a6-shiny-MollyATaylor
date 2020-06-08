library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(shinythemes)

avg_state_poverty <- midwest %>%
  group_by(state) %>%
  summarize(adult_poverty = mean(percadultpoverty),
            popdensity = mean(popdensity))

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("flatly"),
                # Application title
                titlePanel("Midwest Population Data"),
                # Show a plot of the generated distribution
                fluidRow(
                  column(1),
                  column(
                    5,
                    tabsetPanel(
                      tabPanel(
                        "Plot1",
                        selectInput(
                          inputId = "bar_chart",
                          label = "Select a state",
                          choices = sort(c("ALL", avg_state_poverty$state)),
                          selected = "ALL",
                          selectize = FALSE
                        ),

                        radioButtons(
                          inputId = "dens_color",
                          label = "Population density color gradient:",
                          choices = c("On", "Off")
                        ),

                        plotlyOutput("bar_graph")
                      ),

                      tabPanel("Plot2",
                               selectInput(
                                 inputId = "scatter",
                                 label = "Dropdown",
                                 choices = sort(c("Percent White",
                                                  "Percent Black",
                                                  "Percent American Indian",
                                                  "Percent Asian",
                                                  "Percent Other")),
                                 selectize = FALSE
                               ),

                               selectInput(
                                 inputId = "choose_state",
                                 label = "Choose States to Show",
                                 choices = sort(c(avg_state_poverty$state)),
                                 multiple = T,
                                 selected = c("IL", "OH", "IN")
                               ),

                               plotlyOutput("scatter_plot"),
                      )
                    )
                  ),
                  column(1),
                )
)