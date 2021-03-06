###################################################################################
## COVOID-d: COvid-19 Open-source Infection Dynamics
###################################################################################

# Extensions to the Doherty Model: Phased Interventions (pint)

###################################################################################

# Load the mathJax library
withMathJax()

# Define the dashboard header
header <- dashboardHeader(title = "COVID-19 Open-source Infection Dynamics", titleWidth = 420,
                          tags$li(class="dropdown",
                                  tags$a(href='https://github.com/CBDRH/',
                                         icon('github'), "Source Code", target="_blank"))
)


#######################################################
                    ### Sidebar ###
#######################################################

# Sidebar (icons from https://fontawesome.com/icons)
sidebar <- dashboardSidebar(
    h3("COVOID | SIR Model"),
    sidebarMenu(
        menuItem("Parameterise model", tabName = "model", icon = icon("project-diagram")),
        menuItem("Define interventions", tabName = "intervention", icon = icon("user-md")),
        menuItem("Run simulation", tabName = "results", icon = icon("chart-bar")),
        menuItem("Prepare report", tabName = "canvas", icon = icon("palette")),
        menuItem("Animate results", tabName = "video", icon = icon("video")),
        menuItem("Download data", tabName = "data", icon = icon("file-excel")),
        menuItem("Information", tabName = "info", icon = icon("info-circle"))
    ), # Closes sidebarMenu

    dateRangeInput('dateRange',
                   label = span(tagList(icon('calendar-alt'), 'Date range')),
                   start = '2020-03-01', end = '2020-09-30'
                   )

) # closes Sideboard


#######################################################
                    ### Body ###
#######################################################

## Define the Body
body <- dashboardBody(



    ### Extended Doherty Model
    tabItems(
                    # The model
                    tabItem(tabName = "model",
                           fluidPage(
                               div(style="text-align:center",
                                   box(width = "100%", background = "purple",
                                   h4(HTML(paste(icon("project-diagram"), "Parameterise model"))))
                                ),

                             fluidRow(
                                 column(width=4, h3("Transmission model of COVID-19 infection"),
                                        helpText(HTML("The figure to the right represents the compartmental transition model presented by
                                                          <a href='https://www.doherty.edu.au/uploads/content_doc/McVernon_Modelling_COVID-19_07Apr1_with_appendix.pdf' target='_blank'>
                                                          Moss et al (2020)
                                                        </a>
                                                      used to model the impact of COVID-19 in Australia.
                                                      <br/><br/>
                                                      <strong>Nodes</strong> represent compartments, or groups of individuals in the population defined by their status
                                                      with respect to COVID-19.
                                                      <br/><br/>
                                                      <strong>Edges</strong> represent transition pathways between the compartments. The parameterisation of the model determines
                                                      the likelihood of transitioning from one compartment to another along these pathways.
                                                      <br/><br/>
                                                      <strong>Hover</strong> over a node or edge to view the underlying parameter.
                                                      <br/><br/>
                                                      <strong>Click</strong> on a node or edge to find out more information or modify the underlying parameters.
                                                      "
                                                      ))
                                 ),

                                 column(width=8,
                                        box(width=NULL, height = "400px", status = "success", solidHeader = FALSE,
                                            visNetworkOutput("network_d", height = "180px", width = "100%")
                                        )
                                 )
                             ),

                             fluidRow(
                                column(width=2,
                                        box(title=NULL, width=NULL, height = "250px", status = "info", solidHeader = FALSE,
                                            htmlOutput("summary1")
                                        )
                                 ),
                                column(width=2,
                                       box(width=NULL, status = "info", height = '250px', solidHeader = FALSE,
                                           htmlOutput("summary2")
                                       )
                                ),
                                column(width=2,
                                       box(width=NULL, status = "info", height = '250px', solidHeader = FALSE,
                                           htmlOutput("summary3")
                                       )
                                ),
                                column(width=2,
                                       box(width=NULL, status = "info", height = '250px', solidHeader = FALSE,
                                           htmlOutput("summary4")
                                           )
                                ),
                                column(width=2,
                                       box(width=NULL, status = "info", height = '250px', solidHeader = FALSE
                                       )
                                )
                             )

                        )  # Closes fluidPage
                    ), # Closes tabItem

                    # Interventions
                    tabItem(tabName = "intervention",
                             fluidPage(
                                 div(style="text-align:center",
                                     box(width = "100%", background = "purple",
                                         h4(HTML(paste(icon("user-md"), "Define interventions"))))
                                 ),

                                 column(width = 4,
                                     box(width="100%", height = "700px",
                                         title = "About interventions",
                                         status = "info", solidHeader = FALSE,

                                         HTML(paste("The", tags$code("COVOID"), "package allows you to implement two different tyoes of intervention: (i)
                                                    interventions that target the probability of transmission; and (ii) interventions that target the
                                                    number of contacts between individuals. Both types of interventions can be time-fixed or time-varying.
                                                    To specify an intervention, use the panels to the right. All interventions are specified in relative terms
                                                    (i.e. relative to the pre-pandemic levels).")),
                                         br(), br(),

                                         HTML(paste(icon("handshake"), strong("Transmission probability"))),
                                         p("These interventions mimic the effect of measures that target the probability of transmitting the virus between
                                           infectious and susceptible individuals, such as wearing faces masks and hand-washing."),

                                         HTML(paste(icon("users"), strong("Social contacts"))),
                                         p("These interventions mimic the effect of measures that target the number of face-to-face contacts
                                           between individuals in the population, such as quarantine, school closures, working from home and
                                           other 'lockdown' measures."),


                                         hr(),

                                         helpText("By default, interventions targetting social contacts are applied to all types of contacts. However,
                                                    specific interventions can be tailored to contacts in different settings, including school, work
                                                  and home. If you would like to tailor interventions to contacts in specific settings, select these below."),

                                         checkboxGroupInput("intSetting_c", "Tailor intervention to specific setting(s):", inline = TRUE,
                                                        choices=list("School" = "school", "Work" = "work", "Home" = "home"))

                                    )
                                 ),

                                 div(style = 'overflow-y:scroll;height:700px;',
                                 column(width = 12,

                                        box(width="100%", collapsible = TRUE, solidHeader = TRUE, collapsed = TRUE,
                                            title = HTML(paste(icon("handshake"), "Transmission probability", sparklineOutput("sparklineGeneral_t"))),
                                            column(width = 7,
                                                   plotOutput("intGeneral_t", height = 270,
                                                              click = "intGeneral_click_t",
                                                              dblclick = "intGeneral_dblclick_t",
                                                              hover = hoverOpts("intGeneral_hover_t", delay=100, delayType = "debounce")
                                                   ),
                                                   textOutput("tooltipGeneral_t"),
                                                   helpText("Click to add a point. Double-click to remove."),
                                                   hr(),
                                                   actionButton("resetGeneral_t", "Reset"),
                                                   actionButton("undoGeneral_t", "Undo")
                                            ),

                                            column(width = 5,
                                                   DTOutput("reviewGeneral_t")
                                            )
                                        ), # Closes box

                                     # All
                                         box(width="100%", collapsible = TRUE, solidHeader = TRUE, collapsed = TRUE,
                                             title = HTML(paste(icon("users"), "Social contacts", sparklineOutput("sparklineGeneral_c"))),
                                             helpText("If school, work, or home-based interventions are selected, those contacts will be excluded from the intervention specified here."),
                                             column(width = 7,
                                                    plotOutput("intGeneral_c", height = 270,
                                                               click = "intGeneral_click_c",
                                                               dblclick = "intGeneral_dblclick_c",
                                                               hover = hoverOpts("intGeneral_hover_c", delay=100, delayType = "debounce")
                                                               ),
                                                    textOutput("tooltipGeneral_c"),
                                                    helpText("Click to add a point. Double-click to remove."),
                                                    hr(),
                                                    actionButton("resetGeneral_c", "Reset"),
                                                    actionButton("undoGeneral_c", "Undo")
                                             ),

                                             column(width = 5,
                                                    DTOutput("reviewGeneral_c")
                                             )
                                         ), # Closes box

                                 # Schools
                                 conditionalPanel(

                                     condition = "input.intSetting_c.includes('school')",
                                         box(width="100%", collapsible = TRUE, solidHeader = TRUE, collapsed = TRUE,
                                             title = HTML(paste(icon("school"), "Contacts at school", sparklineOutput("sparklineSchool_c"))),
                                             helpText("Apply a distinct intervention for school-based contacts"),
                                             column(width = 7,
                                             plotOutput("intSchool_c", height = 270,
                                                        click = "intSchool_click_c",
                                                        dblclick = "intSchool_dblclick_c",
                                                        hover = hoverOpts("intSchool_hover_c", delay=100, delayType = "debounce")
                                                        ),
                                             textOutput("tooltipSchool_c"),
                                             helpText("Click to add a point. Double-click to remove."),
                                             hr(),
                                             actionButton("resetSchool_c", "Reset"),
                                             actionButton("undoSchool_c", "Undo")
                                             ),

                                             column(width = 5,
                                                    DTOutput("reviewSchool_c")
                                                    )
                                     ) # Closes box
                                 ), # Closes Conditional panel

                                 # Work
                                 conditionalPanel(

                                     condition = "input.intSetting_c.includes('work')",
                                     box(width="100%", collapsible = TRUE, solidHeader = TRUE, collapsed = TRUE,
                                         title = HTML(paste(icon("building"), "Contacts at work", sparklineOutput("sparklineWork_c"))),
                                         helpText("Apply a distinct intervention for work-based contacts"),
                                         column(width = 7,
                                                plotOutput("intWork_c", height = 270,
                                                           click = "intWork_click_c",
                                                           dblclick = "intWork_dblclick_c",
                                                           hover = hoverOpts("intWork_hover_c", delay=100, delayType = "debounce")
                                                           ),
                                                textOutput("tooltipWork_c"),
                                                helpText("Click to add a point. Double-click to remove."),
                                                hr(),
                                                actionButton("resetWork_c", "Reset"),
                                                actionButton("undoWork_c", "Undo")
                                         ),

                                         column(width = 5,
                                                DTOutput("reviewWork_c")
                                         )
                                     ) # Closes box
                                 ), # Closes Conditional panel

                                 # Home
                                 conditionalPanel(

                                     condition = "input.intSetting_c.includes('home')",
                                     box(width="100%", collapsible = TRUE, solidHeader = TRUE, collapsed = TRUE,
                                         title = HTML(paste(icon("home"), "Contacts at home")),
                                         sparklineOutput("sparklineHome_c"),
                                         helpText("Apply a distinct intervention for work-based contacts"),
                                         column(width = 7,
                                                plotOutput("intHome_c", height = 270,
                                                           click = "intHome_click_c",
                                                           dblclick = "intHome_dblclick_c",
                                                           hover = hoverOpts("intHome_hover_c", delay=100, delayType = "debounce")
                                                ),
                                                textOutput("tooltipHome_c"),
                                                helpText("Click to add a point. Double-click to remove."),
                                                hr(),
                                                actionButton("resetHome_c", "Reset"),
                                                actionButton("undoHome_c", "Undo")
                                         ),

                                         column(width = 5,
                                                DTOutput("reviewHome_c")
                                         )
                                     ) # Closes box
                                 ) # Closes Conditional panel

                                 ) # Closes Right-Hand column
                            ) # Closes div
                        )  # Closes fluidPage


                    ), # Closes tabPanel

                    # Results
                    tabItem(tabName = "results",
                            div(style="text-align:center",
                                box(width = "100%", background = "purple",
                                    h4(HTML(paste(icon("chart-bar"), "Run simulation"))))
                            ),
                             fluidRow(
                                 column(width=3,
                                        box(title = NULL, width=NULL, height="700px",
                                            status = "success", solidHeader = FALSE,
                                            actionButton(inputId = "runMod", "Run Model",
                                                         icon = icon("paper-plane"),
                                                         width = '100%',
                                                         class = "btn-success"),

                                            hr(),
                                            checkboxGroupInput("plotvars", "Compartments to include",
                                                               choices = list(
                                                                   "Susceptible" = "S",
                                                                   "Infectious" = "I",
                                                                   "Recovered" = "R"),
                                                               selected=c("I")
                                            ),
                                            hr(),
                                            radioButtons("scale", "Scale",
                                                         choices = list(
                                                             "Count",
                                                             "Percent",
                                                             "Per 100,000"),
                                                         inline = TRUE,
                                                         selected=c("Count")
                                            ),
                                            materialSwitch("logScale", "Log scale", FALSE, inline=TRUE, status = "info"),
                                            hr(),
                                            sliderInput("ndays",
                                                        "Number of days to plot:",
                                                        min=0, step=1, max=365, value=100),
                                            selectizeInput("compCountries", "Compare to existing data:", choices = unique(covid19_data$Country.Region), selected = "Australia", multiple = FALSE),
                                            selectizeInput("compProvince", "Specify province or state (where available):", choices = unique(covid19_data$Province.State), selected = "New South Wales", multiple = FALSE)
                                            )
                                 ),

                                 column(width=6,
                                        box(title = tagList(shiny::icon("chart-area"), "Simulation results: Incidence over time"),
                                            width = "100%", height="700px", status = "primary", solidHeader = FALSE,
                                            withLoader(ggiraphOutput("plot"), type="image", loader="SARS-CoV-2.gif"),
                                            downloadButton('downloadPlot','Download Plot', icon=icon("download"), width="100%", class = "btn-info")
                                        )
                                 ),

                                 column(width=3,
                                        box(title = NULL,
                                            width = "100%", height="700px", status = "primary", solidHeader = FALSE,
                                            actionButton("toreport", label="Add to my report canvas", icon("palette"), class = "btn-success"),
                                            helpText("Plots that are added to your report canvas can be reviewed and captioned later.
                                                     You can also download these files as part of a customisable report for easy sharing."),
                                            hr(),
                                            radioButtons("reportFigs", label = "What figure should this appear as?",
                                                         choices = list("Figure 1" = 1, "Figure 2" = 2, "Figure 3" = 3, "Figure 4" = 4, "Figure 5" = 5, "Figure 6" = 6),
                                                         selected = NULL, inline =  FALSE)
                                        )
                                 ),


                             )
                    ),

                    # Dynamic report
                    tabItem(tabName = "canvas",
                            div(style="text-align:center",
                                box(width = "100%", background = "purple",
                                    h4(HTML(paste(icon("palette"), "Prepare report"))))
                            ),
                                 fluidRow(
                                 box(width=NULL, status = "info", solidHeader = FALSE,
                                     column(width=3,
                                            textInput("reportname", label=NULL, value="", placeholder = "my-report")
                                     ),
                                     column(width=3,
                                            prettyCheckbox(inputId = "datelab", "yyyy-mm-dd tag?", icon = icon("check"),
                                                           status = "default", shape = "curve", animation = "pulse", value = TRUE)
                                     ),
                                     column(width=3,
                                            radioButtons(
                                                inputId = "format", label = NULL,
                                                choices = c("HTML"),
                                                selected = "HTML")
                                     ),
                                     column(width=3,
                                            withLoader(downloadButton("downloadReport", "Download report",
                                                           icon = icon("file-download"),
                                                           width = '100%',
                                                           class = "btn-info"), type="image", loader="SARS-CoV-2.gif")
                                     )
                                 ),

                                 ),

                             conditionalPanel("output.nPlots>=1",
                                              fluidRow(
                                                  column(width = 2,
                                                         materialSwitch("inclPlot1", "Include this plot in your downloadable report?", value = FALSE, status = "success"),
                                                  ),

                                                  column(width = 5,
                                                         textInput("p1title", "Add a title for this plot", width="100%", placeholder = "Figure 1"),
                                                         textAreaInput("p1comment", "Add a comment on this plot", width="400px", height="200px")
                                                  ),

                                                  column(width = 5,
                                                         ggiraphOutput("extplot1", width='100%', height='300px')
                                                  )
                                              ),
                                              hr()
                                        ),
                             conditionalPanel("output.nPlots>=2",
                                              fluidRow(
                                                  column(width = 2,
                                                         materialSwitch("inclPlot2", "Include this plot in your downloadable report?", value = FALSE, status = "success"),
                                                  ),

                                                  column(width = 5,
                                                         textInput("p2title", "Add a title for this plot", width="100%", placeholder = "Figure 2"),
                                                         textAreaInput("p2comment", "Add a comment on this plot", width="400px", height="200px")
                                                  ),

                                                  column(width = 5,
                                                         ggiraphOutput("extplot2", width='100%', height='300px')
                                                  )
                                              ),
                                              hr()
                                        ),
                             conditionalPanel("output.nPlots>=3",
                                              fluidRow(
                                                  column(width = 2,
                                                         materialSwitch("inclPlot3", "Include this plot in your downloadable report?", value = FALSE, status = "success"),
                                                  ),

                                                  column(width = 5,
                                                         textInput("p3title", "Add a title for this plot", width="100%", placeholder = "Figure 3"),
                                                         textAreaInput("p3comment", "Add a comment on this plot", width="400px", height="200px")
                                                  ),

                                                  column(width = 5,
                                                         ggiraphOutput("extplot3", width='100%', height='300px')
                                                  )
                                              ),
                                              hr()
                                        ),
                             conditionalPanel("output.nPlots>=4",
                                              fluidRow(
                                                  column(width = 2,
                                                         materialSwitch("inclPlot4", "Include this plot in your downloadable report?", value = FALSE, status = "success"),
                                                  ),

                                                  column(width = 5,
                                                         textInput("p4title", "Add a title for this plot", width="100%", placeholder = "Figure 4"),
                                                         textAreaInput("p4comment", "Add a comment on this plot", width="400px", height="200px")
                                                  ),

                                                  column(width = 5,
                                                         ggiraphOutput("extplot4", width='100%', height='300px')
                                                  )
                                              ),
                                              hr()
                                        ),
                             conditionalPanel("output.nPlots>=5",
                                              fluidRow(
                                                  column(width = 2,
                                                         materialSwitch("inclPlot5", "Include this plot in your downloadable report?", value = FALSE, status = "success"),
                                                  ),

                                                  column(width = 5,
                                                         textInput("p5title", "Add a title for this plot", width="100%", placeholder = "Figure 5"),
                                                         textAreaInput("p5comment", "Add a comment on this plot", width="400px", height="200px")
                                                  ),

                                                  column(width = 5,
                                                         ggiraphOutput("extplot5", width='100%', height='300px')
                                                  )
                                              ),
                                              hr()
                                        ),

                             conditionalPanel("output.nPlots>=6",
                                              fluidRow(
                                                  column(width = 2,
                                                         materialSwitch("inclPlot6", "Include this plot in your downloadable report?", value = FALSE, status = "success"),
                                                  ),

                                                  column(width = 5,
                                                         textInput("p6title", "Add a title for this plot", width="100%", placeholder = "Figure 6"),
                                                         textAreaInput("p6comment", "Add a comment on this plot", width="400px", height="200px")
                                                  ),

                                                  column(width = 5,
                                                         ggiraphOutput("extplot6", width='100%', height='300px')
                                                  )
                                              ))
                    ),



                    # Animate results
                    tabItem(tabName = "video",
                            div(style="text-align:center",
                                box(width = "100%", background = "purple",
                                    h4(HTML(paste(icon("video"), "Animate results"))))
                            ),

                            fluidRow(
                                column(width=3,
                                       box(title = NULL, width="100%", height = "600px",
                                           status = "success", solidHeader = FALSE,
                                           checkboxGroupInput("plotvars_a", "Compartments to include",
                                                              choices = list(
                                                                  "Susceptible" = "S",
                                                                  "Infectious" = "I",
                                                                  "Recovered" = "R"),
                                                              selected=c("I")
                                           ),
                                           hr(),
                                           radioButtons("scale_a", "Scale",
                                                        choices = list(
                                                            "Count",
                                                            "Percent",
                                                            "Per 100,000"),
                                                        inline = FALSE,
                                                        selected=c("Count")
                                           ),
                                           materialSwitch("logScale_a", "Log scale", FALSE, inline=TRUE, status = "info"),
                                           hr(),
                                           sliderInput("ndays_a",
                                                       "Number of days to animate:",
                                                       min=0, step=1, max=365, value=365),
                                           hr(),
                                           helpText("Right-click to download the gif")
                                       )
                                ),

                                column(width=6,
                                       box(title = tagList(shiny::icon("chart-area"), "Simulation results: Incidence over time"),
                                           width = "100%", height = "600px", status = "primary", solidHeader = FALSE,
                                           withLoader(imageOutput("animation"), type="image", loader="SARS-CoV-2.gif")
                                       )
                                ),

                                column(width=3,
                                       box(title = NULL,
                                           width = "100%", height = "600px", status = "primary", solidHeader = FALSE,
                                           helpText("Here you can visualise disease transition over time. Design the plot you would
                                                     like to animate then click on Create Animation to view. If no preview appears below, make sure that you have run a model."),
                                           h4("Animation preview"),
                                           ggiraphOutput("animation_preview", width='100%', height='200px'),
                                           actionButton(inputId = "runAni", "Create Animation",
                                                        icon = icon("play"),
                                                        width = '100%',
                                                        class = "btn-success")
                                       )
                                )
                            )

                    ),


                    # Data
                    tabItem(tabName = "data",
                            div(style="text-align:center",
                                box(width = "100%", background = "purple",
                                    h4(HTML(paste(icon("file-excel"), "Download data"))))
                            ),
                             helpText("Once you run a model you will be able to view and download the data here."),
                             DT::dataTableOutput("mod_df_wide"),
                             hr(),
                             conditionalPanel("output.mod_df_wide",
                                downloadLink("get_wide_data", label = HTML(paste("Download the data", icon("download"))))
                             )
                    ),
                    # About
                    tabItem(tabName = "info",
                            div(style="text-align:center",
                                box(width = "100%", background = "purple",
                                    h4(HTML(paste(icon("info-circle"), "Information"))))
                            ),
                             h3("Well head")
                    )

                ) # Closes tabsetPanel

) # Closes dashboardBody


# Put them together into a dashboardPage
dashboardPage(
    header,
    sidebar,
    body
)

