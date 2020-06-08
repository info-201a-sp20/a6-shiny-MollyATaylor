# Define server logic required to draw a histogram
server <- function(input, output) {
  # create a reactive dataframe
  plotting_df <- reactive({
    if ("ALL" %in% input$bar_chart) {
      outdf <- avg_state_poverty %>%
        rename(x_axis = state, yaxis = adult_poverty)
    } else {
      outdf <- midwest %>%
        filter(state == input$bar_chart) %>%
        rename(x_axis = county, yaxis = percadultpoverty)
    }
    return(outdf)
  })

  x_lab <- reactive({
    if ("ALL" %in% input$bar_chart) {
      "State"
    } else {
      "County"
    }
  })

  output$bar_graph <- renderPlotly({

    if (input$dens_color == "On") {
      plot_ly(data = plotting_df(),  # grab the reactive dataframe
              x = ~x_axis,
              y = ~yaxis,
              marker = list(
                colorscale = "Rainbow",
                color = ~popdensity,
                colorbar = list(
                  title = "Pop density by person"
                )
              ),
              type = "bar") %>%
        layout(
          title = "Percent impoverished adults by location",
          xaxis = list(title = x_lab(), showticklabels = FALSE),
          yaxis = list(title = "Percent adults living in poverty")
        )

    } else {
      plot_ly(data = plotting_df(),  # grab the reactive dataframe
              x = ~x_axis,
              y = ~yaxis,
              type = "bar") %>%
        layout(
          title = "% impoverished adults by location",
          xaxis = list(title = x_lab(), showticklabels = FALSE),
          yaxis = list(title = "% adults living in poverty")
        )
    }
  })

  ethnicity <- reactive({
    if ("Percent American Indian" %in% input$scatter) {
      "percamerindan"
    } else if ("Percent Asian" %in% input$scatter) {
      "percasian"
    } else if ("Percent Black" %in% input$scatter) {
      "percblack"
    } else if ("Percent Other" %in% input$scatter) {
      "percother"
    } else if ("Percent White" %in% input$scatter) {
      "percwhite"
    }

  })

  output$scatter_plot <- renderPlotly({
    plot_ly(data = midwest %>%
              filter(state %in% input$choose_state) %>%
              rename(selected_eth = ethnicity()),
            x = ~selected_eth,
            y = ~percadultpoverty,
            type = "scatter",
            mode = "markers"

    ) %>%
      layout(
        title = "Percent impoverished adults by percent ethnicity prevalence",
        xaxis = list(title = input$scatter),
        yaxis = list(title = "Percent adults living in poverty")
      )
  })
}