###############################################################################
#####   RECAN - Scaling  ######################################################
###############################################################################
##  Authors:  Alvin Walker, Katarina Zatkova, Manuela Ott, Malgorzata Roos   ##
##  Version:  1.0                                                            ##
##  Date: 28.08.2026                                                                  ##
###############################################################################
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
#  
# This R code and Shiny application are made freely accessible under
# the GNU Affero General Public License  >= 3
# SPDX-License-Identifier: AGPL-3.0-or-later 
# (AGPL-3.0-or-later,  https://www.gnu.org/licenses/licenses.html.en#AGPL).
#
#
#

# Libraries
#install.packages(c("bslib", "kableExtra", "knitr", "shiny", "shinyscreenshot"))
 
library(kableExtra)
library(knitr)
library(shiny)
library(bslib)
library(shinyscreenshot)


##
## Main functions
##

########################
## UI - Information  #########################################################
########################
#
# This section contains all UI elements of the information page 
# They are saved in functions, that are then called from the main app.
# 


##
## Main title and text --------------------------------------------------------
##

introduction <- function(){
  tagList(
    tags$div(style = "height:20px"),
    tags$h1("RECAN-scaling: Shiny web application for the scaling of recruitment rates in predictions at the design of medical studies", style = "color:black"),
    tags$h3("Probabilistic predictions of recruitment time and subject count based on a Poisson process with a constant 
            recruitment rate over time", style = "color:grey"),
    tags$div(style = "height:20px"),
    tags$h3("Welcome"),
    p("This Shiny application is a user-friendly, interactive tool that scales 
      recruitment rates which are constant over time and generates probabilistic 
      predictions that account for the inherent stochastic variability of the 
      recruitment process. Study designers, principal investigators, study managers,
      researchers and clinicians without coding experience or statistical expertise 
      can use it to assess how increasing or decreasing the recruitment rate value 
      by a scaling factor affects predictions of recruitment time and subject counts.
      Users can interactively change their assumptions to instantly obtain updated plots,
      estimates, and interpretations. This enables them to efficiently make informed 
      decisions accounting for the stochastic variability of recruitment processes 
      when designing and planning medical studies."),
  )
}

##
## text below mode selection --------------------------------------------------
##

about <- function(){
  tagList(
    tags$h3("About this app"),
    
    # Large part of output is saved in a server in order to manipulate formatting more easily
    uiOutput("general_about"),
    
    tags$h5("Authors"),
    p("Alvin Walker, Katarina Zatkova, Manuela Ott, Malgorzata Roos"),
    #tags$div(style = "height:40px"),
    
    tags$h5("Disclaimer"),
    p("The predictions provided by this Shiny application are only as reliable
      as the information given as input by the user. Moreover, they apply only
      if the recruitment rate is approximately constant over time. The authors of this Shiny application take no responsibility for decisions
      made using its outputs."),
    
    
    tags$h5("License for software"),
    p("The R software and Shiny application are made freely accessible under
      the GNU Affero General Public License >= 3,  (https://www.gnu.org/licenses/licenses.html.en#AGPL)."),
    p("SPDX-License-Identifier: AGPL-3.0-or-later"),
    
    tags$h5("Acknowledgement"),
    p("This Shiny application was created as a part of the DSRA project funded by the Swiss National Science Foundation (#10002316).
      The work of Alvin Samuel Walker was funded by Professor Leonhard Held, the head of the Biostatistics Department at the Biostatistics, Prevention and Epidemiology Institute at the University of Zurich.")
  )
  
}


##
## Saved in server function for ease of use ------------------------------------
##


about_output <- function(input, output){
  
  output$general_about <- renderUI({
    tagList(
      p("This free-of-charge, open-source Shiny application addresses the 
      challenging task of quantifying the impact of changes in the expected 
      average recruitment rate on predictions of recruitment time and subject 
      counts. This task typically arises at the design stage of medical studies
      and in ongoing studies when predicting the future recruitment progress. 
      To predict recruitment time and subject count, this application uses a
      homogeneous Poisson process with a recruitment rate", "\u03bb" , "which is
      constant over time. The \"Scaling of recruitment rates\" tab focuses on 
      cases where the scaling factor", tags$i("f", style = "font-family:'Calibri';"),  "reflects an administrative action that 
      alters the recruitment rate. Alternatively, it can also reflect a 
      retention factor that lengthens the recruitment time or reduces the count 
      of subjects available for the final statistical analysis. The \"Converting
      time units\" tab uses the scaling factor", tags$i("f", style = "font-family:'Calibri'"),"to convert time units between
      days, weeks, months, and years. Both tabs allow users to scale the
      recruitment rate value and instantly obtain updated plots, estimates, 
      and interpretations. This output enables users to easily assess the impact
      of altering the recruitment rate value by a scaling factor on predictions
      of recruitment time and subject counts. In addition, the output can be
      exported to a png file and submitted to a funding agency, institutional 
      review board, or ethics committee alongside a study protocol. 
      These features make the Shiny application a valuable tool for efficient
      decision-making at various stages, from the planning stage to ongoing
      studies.")
    )
    
  })
  
  
}

###
### Scaling card text and buttons --------------------------------------------
###

scaling_rate_card <- function(){
  tagList(
    p("This tab shows the effect of increasing or decreasing the constant
    recruitment rate", "\u03bb", "by a factor", tags$i("f"), "on the predictions
    of recruitment time and subject count."),
    
    p(tags$ul(
      tags$li(
        "Click on the Time button to model the recruitment time required to 
      recruit a given count C", tags$sub("target"), "of subjects."),
      
      tags$li("Click on the Count button to model the count of subjects that
              will be recruited within a given time T", tags$sub("target"), ".")
      
    )),
    
    layout_columns(
      actionButton("time_scale_1", label = "Time"),
      actionButton("count_scale_1", label = "Count")
    )
    
  )
  
}


###
### Converting card text and buttons ------------------------------------------
###




converting_rate_card <- function(){
  tagList(
    p("This tab shows the effect of converting the time unit of predictions.
    It can convert the time scale of predictions between
      days, weeks, months and years."),
    p(tags$ul(
      tags$li(
        "Click on the Time button to model the recruitment time required to 
      recruit a given count C", tags$sub("target"), "of subjects."),
      
      tags$li("Click on the Count button to model the count of subjects that
              will be recruited within a given time T", tags$sub("target"), ".")
    )),
    
    layout_columns(
      actionButton("time_scale_4", label = "Time"),
      actionButton("count_scale_4", label = "Count")
    )
  )
}


########################
## UI - Scaling  #########################################################
########################
#
# This section contains all UI elements of the scaling page
# They are saved in functions, that are then called from the main app file.
# 

##
## Output function UI scaling -------------------------------------------------
##

scaling_input <- function(){
  tagList(
    
    tags$h6("Prediction mode"),
    
    uiOutput("mode_switcher_1"), 
    
    tags$h6("User input"),
    
    uiOutput("c_t_input_UI"),
    
  )
  
}

# Selects scaling mode

pred_scaling_mode <- function(input, output){
  
  output$mode_switcher_1 <- renderUI({
    tagList(
      layout_columns(
        selectInput("mode_switch",label = "Switch prediction mode",
                    choices = c("recruitment counts", "recruitment time"),
                    selected = buf_pred_mode(), width = "200px"),
        
        textInput("count_unit", label = "Counting unit (plural)", value = buf_C_unit(),
                  width = "200px"),
        
        col_widths = c(6,6)
        
        
      )
    )
  })  
  
}


select_UI <- function(input, output){
  output$c_t_input_UI <- renderUI({
    if (input$mode_switch == "recruitment time") {
      UI_time_to_count()
    } else {
      UI_count_in_time()
    }
  })
}

##
## UI for count prediction in a given time -------------------------------------
##

UI_count_in_time <- function(){
  
  tagList(
    layout_columns(
      
      numericInput("lambda", label = p("Recruitment rate", "\u03bb"), value = buf_lmb(),
                   min = 0, max = 100, width = "200px"),
      selectInput("lmb_time_unit", "Unit of time",
                  choices = c("day", "week", "month", "year"),
                  selected = buf_T_unit(), width = "200px"),
      
      numericInput("time", label = p("Target time", "T", tags$sub("target")), value =  buf_T_target(),
                   min = 1, max = 300, width = "200px"),
      
      
      col_widths = c(6,6,6)
    ),
    
    tags$h6("Scaling"),
    
    # Slider functions can be found in helper functions
    
    uiOutput("slider_ff"),
    
    
    if(is.null(buf_lmb()) | is.na(buf_lmb()) |
       buf_lmb() == "" | buf_lmb() == 0 ){
      uiOutput("")
    } else {
      uiOutput("slider_lambda")
    },
    
    
    span(textOutput("count_text"), 
         style = "color:green"),
    
    actionButton("save_scaling", label = "Save output to PNG") 
    
  )
}

##
## UI for time predictions within a given time ---------------------------------
## 

UI_time_to_count <- function(){
  
  tagList(
    
    layout_columns(
      
      numericInput("lambda", label = p("Recruitment rate", "\u03bb"), value = buf_lmb(),
                   min = 0, max = 100, width = "200px"),
      
      selectInput("lmb_time_unit", "Unit of time",
                  choices = c("day", "week", "month", "year"),
                  selected = buf_T_unit(), width = "200px"),
      
      numericInput("count", label = p("Target count", "C", tags$sub("target")), value = buf_C_target(),
                   min = 1, max = 300, width = "200px"),
      
      
      col_widths = c(6,6,6)
    ),
    
    tags$h6("Scaling"),
    
    # Slider functions can be found in helper functions
    
    uiOutput("slider_ff"),
    
    if(is.null(buf_lmb()) | is.na(buf_lmb()) |
       buf_lmb() == "" | buf_lmb() == 0 | buf_C_target() == 0){
      uiOutput("")
    } else {
      uiOutput("slider_lambda")
    },
    
    # Time text found below
    
    span(textOutput("time_text"), 
         style = "color:green"),
    
    actionButton("save_scaling", label = "Save output to PNG") 
  )
  
}

##
## Generates text below input (exceptionally server in UI section) ----------------
##

input_text <- function(input, output){
  
  output$count_text <- renderText({
    if(is.numeric(T_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() != 0){
      paste0("You are predicting the count of ", count_unit(), " recruited after ",
             T_target(), " ", time_unit(), "s with a recruitment rate of ",
             lmb(), " ", count_unit(), " per ", time_unit(), ". After scaling,
              this recruitment rate becomes ", round(lmb_scaled(),3), " ", count_unit(), " per ",
             time_unit(), ".")
    } else {paste("")}
  })
  
  output$time_text <- renderText({
    if(is.numeric(C_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() != 0){
      paste0("You are predicting the amount of time needed to recruit ", 
             C_target(), " ", count_unit(), " with a recruitment rate of ",
             lmb(), " ", count_unit(), " per ", time_unit(), ". After scaling,
             this recruitment rate becomes ", round(lmb_scaled(),3), " ", count_unit(), " per ",
             time_unit(), ".")
    } else {paste(" ")}
  })
  
}



########################
## UI - Converting  #########################################################
########################
#
# This section contains all UI elements of the conversion page 
# They are saved in functions, that are then called from the main app.
# 


converting_input <- function(){
  tagList(
    tags$h6("Prediction mode"),
    uiOutput("mode_switcher_4"),
    
    tags$h6("User input"),
    uiOutput("original_in"),
    # tags$h6("New time scale"),
    # uiOutput("converter"),
    tags$h6("Selected transformation"),
    uiOutput("conv_table"),
    uiOutput("conv_text"),
    actionButton("save", label = "Save output to PNG"),
  )
}





original_input <- function(input, output){
  
  output$mode_switcher_4 <- renderUI({
    tagList(
      layout_columns(
        selectInput("mode_switch",label = "Switch prediction mode",
                    choices = c("recruitment counts", "recruitment time"),
                    selected = buf_pred_mode(), width = "250px"),
        textInput("count_unit", label = "Counting unit (plural)", value = buf_C_unit(),
                  width = "250px"),
        
        col_widths = c(6,6)
        
        
        
      )
    )
  }) 
  
  output$countunit_4 <- renderUI({
    textInput("count_unit", label = "Counting unit", value = buf_C_unit(),
              width = "200px")
  })
  
  
  output$original_in <- renderUI(
    tagList(
      layout_columns(
        
        numericInput("lambda", label = p("Recruitment rate", "\u03bb"), value = buf_lmb(),
                     min = 0, max = 100, width = "250px"),
        selectInput("lmb_time_unit", "Original unit of time",
                    choices = c("day", "week", "month", "year"),
                    selected = buf_T_unit(), width = "250px"),
        
        if(pred_mode() == "recruitment counts"){
          numericInput("time", label = p("Original target time", "T", tags$sub("target")), value =  buf_T_target(),
                       min = 1, max = 300, width = "250px")
        } else {
          numericInput("count", label = p("Target count", "C", tags$sub("target")), value =  buf_C_target(),
                       min = 1, max = 300, width = "250px") },
        
        selectInput("new_time", "New unit of time",
                    choices = c("day", "week", "month", "year"),
                    selected = buf_new_time(), width = "250px"),
        
        
        col_widths = c(6,6,6,6)
      )  
    )
  )
}


conversion_text <- function(input, output){
  
  output$conv_text <- renderUI({
    
    if(is.numeric(lmb()) & lmb() != 0){
      p("You are converting the recruitment rate from", lmb(), paste0(buf_C_unit()),
        "per", time_unit(), "to", round(lmb_converted(),3), paste0(buf_C_unit()), "per",
        paste0(new_time(),"."), style = "color:green")
    } else {p()}
  })
  
}



########################
## Server - Variables  ########################################################
########################
#
# This section contains all global variable definitions: 
# - First, non-reactive variables
# - Secondly, reactive variables
# - Third, variables buffers, that enable variables to be saved between tabs
#


##
## 1. Non reactive variables --------------------------------------------------
##

init_non_reactives <- function(input,output){ 
  
  # Colors for count (DSRA colors)
  C_color_dark <<- rgb(255 / 255, 94 / 255, 5 / 255)
  C_color_medium <<- rgb(255 / 255, 165 / 255, 0 / 255)
  C_color_light <<- rgb(255 / 255, 198 / 255, 102 / 255)
  C_color <<- C_color_dark
  
  # Colors for Time (DSRA colors)
  T_color_dark <<- rgb(15 / 255, 82 / 255, 186 / 255)
  T_color_medium <<- rgb(0 / 255, 128 / 255, 255 / 255)
  T_color_light <<- rgb(115 / 255, 194 / 255, 251 / 255)
  T_color <<- T_color_dark
  
  #labels for graphs
  cpf_vals <<- c(0, 20, 40, 60, 80, 100)
  cpf_lab <<- paste0(cpf_vals, "%")
  
  probq_vals <<- c(0.025, 0.25, 0.5, 0.75, 0.975)
  probq_lab <<- c("2.5%", "25%", "50%", "75%", "97.5%")
  
  # Escaped version of the label for the probabilities, to be used as column names
  probq_lab_escaped <<- paste0(100 * probq_vals, " %")
  
}



##
## 2. Reactive variables ------------------------------------------------------
##


init_reactives <- function(input,output){
  
  # Recruitment rate
  lmb <<- debounce(reactive(input$lambda), 1800)
  
  # Target_time
  T_target <<- debounce(reactive(input$time), 1800)
  
  # Target count
  C_target <<- debounce(reactive(input$count), 1800)
  
  # scaling factor
  ff <<- reactive(input$scale_ff)
  
  # scaled lmb
  lmb_scaled <<- reactive( buf_ff() * lmb() )
  
  # Converted lmb
  lmb_converted <<- reactive(
    if (time_unit() == "day") {
      if (new_time() == "day") {
        lmb()
      } else if (new_time() == "week") {
        lmb() * 7
      } else if (new_time() == "month") {
        lmb() * 365 / 12
      } else if (new_time() == "year"){
        lmb() * 365
      }
      
    } else if (time_unit() == "week") {
      if (new_time() == "day") {
        lmb() / 7
      } else if (new_time() == "week") {
        lmb()
      } else if (new_time() == "month") {
        lmb() * 365 / (12*7)
      } else if (new_time() == "year"){
        lmb() * 365 / 7
      }
      
    } else if (time_unit() == "month"){
      if (new_time() == "day") {
        lmb() * 12 / 365
      } else if (new_time() == "week") {
        lmb() * 12 * 7 / 365
      } else if (new_time() == "month") {
        lmb() 
      } else if (new_time() == "year"){
        lmb() * 12
      }
      
    } else if (time_unit() == "year"){
      if (new_time() == "day") {
        lmb() / 365
      } else if (new_time() == "week") {
        lmb() * 7 /365
      } else if (new_time() == "month") {
        lmb() / 12
      } else if (new_time() == "year"){
        lmb()
      }
    }
  )
  
  #new time units
  
  new_time <<- reactive(input$new_time)
  
  new_times <<- reactive(paste0(new_time(),"s"))
  
  # time units
  time_unit <<- reactive(input$lmb_time_unit)
  
  time_units <<- reactive(paste0(time_unit(), "s"))
  
  #graph titles
  
  time_name <<- reactive(paste0(
    toupper(substr(paste0(time_unit(), "s"), 1, 1)),
    tolower(substr(paste0(time_unit(), "s"), 2, nchar(paste0(time_unit(), "s"))))
  ))
  
  #count_unit
  
  count_unit <<- debounce(reactive(input$count_unit), 3000)
  count_units <<- reactive(count_unit())
  
  # count_units <<- reactive(paste0(count_unit(), "s"))
  
  pred_mode <<- reactive(input$mode_switch)
  
} 



##
## 3. Buffers ------------------------------------------------------------------
##



buffers <- function(input, output){
  
  # Buffers for all variables used in multiple tabs
  
  buf_pred_mode <<- reactiveVal("recruitment time")
  observeEvent(pred_mode(),
               buf_pred_mode(pred_mode()))
  observeEvent(input$time_scale_4,
               buf_pred_mode("recruitment time"))
  observeEvent(input$time_scale_1,
               buf_pred_mode("recruitment time"))
  
  buf_lmb <<- reactiveVal(value = 0.591)
  observeEvent(lmb(),
               buf_lmb(lmb()))
  
  buf_T_target <<- reactiveVal(value = 548)
  observeEvent(T_target(),
               buf_T_target(T_target()))
  
  buf_C_target <<- reactiveVal(value = 324)
  observeEvent(C_target(),
               buf_C_target(C_target()))
  
  
  buf_C_unit <<- reactiveVal(value = "participants")
  observeEvent(count_unit(),
               buf_C_unit(count_unit()))
  
  buf_T_unit <<- reactiveVal(value = "day")
  observeEvent(time_unit(),
               buf_T_unit(time_unit()))
  
  buf_new_time <<- reactiveVal(value = "month")
  observeEvent(new_time(),
               buf_new_time(new_time()))
  
  
  ### Interactive sliders
  
  buf_ff <<- reactiveVal(value = 1.06)
  
  
  de_ff <- debounce(reactive({ff()}), 2000)
  
  observeEvent(de_ff(),{
    buf_ff(round(ff(),4))
  })
  
  de_ff_num <- debounce(reactive({input$scale_ff_num}), 2000)
  
  observeEvent(de_ff_num(),{
    if (is.null(de_ff_num()) | is.na(de_ff_num()) |
        de_ff_num() == ""){
      cat("nothing")
    } else {buf_ff(round(de_ff_num(),4))}
  })
  
  de_slide_num <- debounce(reactive({input$slide_lmb_numeric}), 2000)
  
  observeEvent(de_slide_num(),{
    if (is.null(de_slide_num()) | is.na(de_slide_num()) |
        de_slide_num() == ""){
      cat("Value detected as null, ff not updated")
    } else { buf_ff(round(de_slide_num() / lmb(),4)) }           
  })
  
  de_slide_lmb <- debounce(reactive({input$slide_lambda}), 2000)
  
  observeEvent(de_slide_lmb(),
               buf_ff(round(de_slide_lmb() / lmb(),4)))
  
  
  output$buf <- renderText(buf_ff())
}


########################
## Server - Scaling  ########################################################
########################
#
# This section contains all functions used in the scaling module
# - First, the two graphs of distributions at the bottom of the page
# - Second, the accrual graph at the top of the page
# - Third, the text and table at the top of the page
#


##
## 1. Distribution plots ########################################################
##


##
## Count plots ----------------------------------------------------------------
##


# Main Plotting functions

pmf_plot <- function(lmb, lmb_scaled, T_target, C_color,
                     c_xx, c_yyl,
                     subject_unit){
  
  plot(
    x = c_xx,
    y = dpois(x = c_xx, lambda = T_target * lmb),
    type = "n",
    ylim = c(0, c_yyl),
    xlab = paste0("Count (", subject_unit, ")"),
    ylab = "Probability Mass Function",
    main = "",
    las = 1,
    cex.lab = 0.95,
    cex.axis = 0.9
  )
  # Plot the probability mass function for original lmb
  lines(
    c_xx,
    dpois(x = c_xx, lambda = T_target * lmb),
    type = "s",
    col = "dimgrey",
    lwd = 2,
    lty = 1
  )
  # Plot the probability mass function for scaled lmb
  lines(
    c_xx,
    dpois(x = c_xx, lambda = T_target * lmb_scaled),
    type = "s",
    col = C_color,
    lwd = 2,
    lty = 1
  )
  legend(
    "topleft",
    c(expression(paste("original ", lambda)), 
      expression(paste("scaled ", lambda))),
    lty = c(1, 1),
    lwd = c(2, 2),
    col = c("dimgrey", C_color),
    bty = "n"
  )
  
}




cdf_plot <- function(lmb, lmb_scaled, T_target, C_color,
                     c_xxl, c_xxu,
                     subject_unit){
  
  plot(
    x = c(c_xxl:c_xxu),
    y = ppois(q = c(c_xxl:c_xxu), lambda = T_target * lmb) * 100,
    main = "",
    xlab = paste0("Count (", subject_unit, ")"),
    ylab = "Cumulative Probability Function",
    type = "s",
    col = "dimgrey",
    lwd = 2,
    las = 1,
    lty = 1,
    yaxt = "n",
    cex.lab = 0.95,
    cex.axis = 0.9
  )
  # Plot the cumulative probability function for scaled lmb
  lines(x = c(c_xxl:c_xxu),
        y = ppois(q = c(c_xxl:c_xxu), lambda = T_target * lmb_scaled) * 100,
        type = "s",
        col = C_color,
        lwd = 2,
        lty = 1)
  
  # Add tick marks and lines at the probability values in cpf_vals
  axis(2, at = cpf_vals, col.ticks = "black", labels = cpf_lab,
       cex.axis = 0.9, las = 1)
  
  
  abline(h = probq_vals[c(1,3,5)] * 100, col = "gray30", lwd = 1.2, lty = 2)
  abline(h = probq_vals[2] * 100, col = "coral1", lwd = 1.2, lty = 2)
  abline(h = probq_vals[4] * 100, col = "darkgoldenrod1", lwd = 1.2, lty = 2)
  
  legend(
    "topleft",
    c(expression(paste("original ", lambda)), 
      expression(paste("scaled ", lambda))),
    lty = c(1, 1),
    lwd = c(2, 2),
    col = c("dimgrey", C_color),
    bty = "n"
  )
  
  
}


# Helper functions called by plotting functions

count_pmf_graph <- function(input, output){
  
  #Defining boundaries
  
  c_xxl <<- reactive(min(qpois(p = 0.001, lambda = T_target() * lmb()),
                         qpois(p = 0.001, lambda = T_target() * lmb_scaled()))
  )
  
  c_xxu <<- reactive(max(qpois(p = 0.999, lambda = T_target() * lmb()),
                         qpois(p = 0.999, lambda = T_target() * lmb_scaled())))
  
  c_xx <<- reactive(c(c_xxl():c_xxu()))
  
  c_yyl <<- reactive(max(dpois(x = c_xx(), lambda = T_target() * lmb()),
                         dpois(x = c_xx(), lambda = T_target() * lmb_scaled())))
  
}



#  Function that call both plots for generation

both_count_graph <- function(){
  
  par(mfrow = c(1,2), mar = c(4,4,1,3))
  
  pmf_plot(lmb = lmb(), lmb_scaled = lmb_scaled(),
           T_target = T_target(), C_color = C_color,
           c_xx = c_xx(), c_yyl = c_yyl(),
           subject_unit = count_unit())  
  
  cdf_plot(lmb = lmb(), lmb_scaled = lmb_scaled(),
           T_target = T_target(), C_color = C_color,
           c_xxl = c_xxl(), c_xxu = c_xxu(), 
           subject_unit = count_unit())
  
}




##
## Time plots ----------------------------------------------------------------
##

# Generating density 

time_density <- function(C_target = C_target,
                         lmb = lmb, lmb_scaled = lmb_scaled,
                         colour = T_color, time_unit = time_unit){
  
  t_xxl <<- min(
    qgamma(p = 0.001, shape = C_target, rate = lmb),
    qgamma(p = 0.001, shape = C_target, rate = lmb_scaled)
  )
  t_xxu <<- max(
    qgamma(p = 0.999, shape = C_target, rate = lmb),
    qgamma(p = 0.999, shape = C_target, rate = lmb_scaled)
  )
  t_yyl <<- max(dgamma(
    x = seq(from = t_xxl, to = t_xxu, length.out = 10000),
    shape = C_target,
    rate = lmb
  ),
  dgamma(
    x = seq(from = t_xxl, to = t_xxu, length.out = 10000),
    shape = C_target,
    rate = lmb_scaled
  ))
  
  # Plot the density for original recruitment rate lmb
  curve(
    dgamma(x, shape = C_target, rate = lmb),
    from = t_xxl,
    to = t_xxu,
    ylim = c(0, t_yyl),
    type = "l",
    col = "dimgrey",
    lty = 1,
    lwd = 2,
    xlab = paste0("Time (", time_unit, "s)"),
    ylab = "Density",
    main = "",
    las = 1,
    cex.lab = 0.95,
    cex.axis = 0.9,
  )
  # Plot the density for scaled lmb
  curve(
    dgamma(x, shape = C_target, rate = lmb_scaled),
    from = t_xxl,
    to = t_xxu,
    col = colour ,
    lwd = 2,
    lty = 1,
    add = TRUE
  )
  legend(
    "topleft",
    c(expression(paste("original ", lambda)), 
      expression(paste("scaled ", lambda))),
    lty = c(1, 1),
    lwd = c(2, 2),
    col = c("dimgrey",colour),
    bty = "n"
  )
  
}



# Generating cumulative distribution

time_cumulative <- function(C_target = C_target,
                            lmb = lmb, lmb_scaled = lmb_scaled,
                            colour = T_color, time_unit = time_unit){
  
  # Confidence values
  cpf_vals <- c(0, 20, 40, 60, 80, 100)
  # Labels for confidence values (on percentage scale)
  cpf_lab <- paste0(cpf_vals, "%")
  
  # Create a grid of 10^4 values & compute the cumulative probability
  # at these values
  grid <- seq(from = t_xxl, to = t_xxu, length.out = 10^4)
  pgvec_original <- pgamma(q = grid, shape = C_target, rate = lmb) * 100
  pgvec_scaled <- pgamma(q = grid, shape = C_target, rate = lmb_scaled) * 100
  plot(
    x = grid,
    y = pgvec_original,
    xlab = paste0("Time (", time_unit, "s)"),
    ylab = "Cumulative Probability Function",
    yaxt = "n",
    type = "n",
    las = 1,
    cex.lab = 0.95,
    cex.axis = 0.9
  )
  
  # Plot the cumulative probability functions for original and scaled lmb
  lines(grid, pgvec_original, col = "dimgrey", type = "l", lwd = 2)
  lines(grid, pgvec_scaled, col = colour, type = "l", lty = 1, lwd = 2)
  
  # Add lines and labels for confidence values
  axis(2, at = cpf_vals, col.ticks = "black", labels = cpf_lab,
       cex.axis = 0.9, las = 1)
  
  abline(h = probq_vals[c(1,3,5)] * 100, col = "gray30", lwd = 1.2, lty = 2)
  abline(h = probq_vals[2] * 100, col = "aquamarine3", lwd = 1.2, lty = 2)
  abline(h = probq_vals[4] * 100, col = "cornflowerblue", lwd = 1.2, lty = 2)
  
  legend(
    "topleft",
    c(expression(paste("original ", lambda)), 
      expression(paste("scaled ", lambda))),
    lty = c(1, 1),
    lwd = c(2, 2),
    col = c("black", T_color),
    bty = "n"
  )
  
}



# Calls both graphs and formulates them nicely


both_time_graph <- function(){
  
  par(mfrow = c(1,2), mar = c(4,4,1,3))
  
  time_density(C_target = C_target(), lmb = lmb(), lmb_scaled = lmb_scaled(),
               colour = T_color, time_unit = time_unit())
  
  time_cumulative(C_target =  C_target(), lmb = lmb(), lmb_scaled = lmb_scaled(),
                  colour = T_color, time_unit = time_unit())
  
  
}


##
## Output function distributions -----------------------------------------------
##
#
# Selects which functions are used to generate plot and makes sure everything all
# values are available
#

cdf_pdf_output <- function(input, output){
  
  output$double_plot <- renderPlot({
    
    if (pred_mode() == "recruitment counts") {
      if(is.numeric(T_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() > 0 &
         buf_T_target() > 0 & buf_ff() > 0){
        both_count_graph()
      } else {
        empty_plot()
      }
    } else { 
      if(is.numeric(C_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() > 0 &
         buf_C_target() > 0 & buf_ff() > 0){
        both_time_graph()
      } else {
        empty_plot()
      }
    }
    
  })
  
  
  
}



##
## 2. Accrual graph ########################################################
##

##
## background grid -------------------------------------------------------------
##

create_cumcount_gridplot <<- function(C_target = C_target, 
                                      T_target = T_target, 
                                      time_unit = time_unit, 
                                      subject_unit = subject_unit, 
                                      time_name = time_name, 
                                      subject_name = subject_name,
                                      x_max = x_max,
                                      y_max = y_max) {
  par(mar = c(4, 4, 2, 5))
  
  plot(
    NA,
    NA,
    ylim = c(0, y_max), #1.25 *Ctarget
    xlim = c(0, x_max), #1.25 *ttarget
    xaxs = "i",
    yaxs = "i",
    xlab = paste0("Time (", time_unit, "s)"),
    ylab = paste0("Cumulative count (", subject_unit, ")"),
    las = 1,
    cex.lab = 1,
    cex.axis = 1
  )
  
  frac_labs <- c("1 / 2", "2 / 2", "3 / 2")
  frac_vals <- c(1 / 2, 2 / 2, 3/ 2)
  
  #Adding vertical and horizontal thin grid
  
  
  for (i in 1:length(frac_labs)) {
    # Add tick marks and labels for time on top
    #T_tick_lab <- bquote(atop(.(bquote(.(frac_labs[i]) ~ T[target])), "(" ~ .(round((frac_vals[i] * T_target), 1)) ~ .(time_name) ~ ")"))
    T_tick_lab <- bquote(.(bquote(.(frac_labs[i]) ~ T[target])))
    axis(3, at = frac_vals[i] * T_target, col.ticks = "black", labels = T_tick_lab, cex.axis = 0.9)
    
    abline(v = frac_vals[i] * T_target, col = "dimgray", lty = 2, lwd = 0.5)
    
    # Add tick marks and labels for counts on the right
    #C_tick_lab <- bquote(atop(.(bquote(.(frac_labs[i]) ~ C[target])), "(" ~ .(ceiling(frac_vals[i] * C_target)) ~ .(subject_name) ~ ")"))
    C_tick_lab <- bquote(.(bquote(.(frac_labs[i]) ~ C[target])))
    axis(4, at = frac_vals[i] * C_target, col.ticks = "black", labels = C_tick_lab, las = 1, cex.axis = 0.9)
    abline(h = frac_vals[i] * C_target, col = "dimgray", lty = 2, lwd = 0.5)
    
  }
}


##
## Accrual for Counts -------------------------------------------------------------
##

create_cumcount_c_base <<- function(T_target, lmb, probq_vals){
  
  tt <- seq(0, 1.5*T_target, length.out = 10)
  polygon_cols <- c("lightgray", "darkgray", "lightgray")
  
  qline1 <- qpois(probq_vals[1], lmb * tt)
  qline2 <- qpois(probq_vals[2], lmb * tt)
  qline3 <- qpois(probq_vals[4], lmb * tt)
  qline4 <- qpois(probq_vals[5], lmb * tt)
  
  polygon(c(tt, rev(tt)),
          c(qline1, rev(qline2)),
          col = polygon_cols[1],
          border = NA)
  
  polygon(c(tt, rev(tt)),
          c(qline2, rev(qline3)),
          col = polygon_cols[2],
          border = NA)
  
  polygon(c(tt, rev(tt)),
          c(qline3, rev(qline4)),
          col = polygon_cols[3],
          border = NA)
}



create_cumcount_c_scaled <<- function(T_target, lmb_scaled, probq_vals, colour){
  
  tt <- seq(0, 1.5*T_target, length.out = 10)
  
  lines(tt, qpois(p = probq_vals[1], lambda = tt * lmb_scaled),
        lwd = 2, lty = 3, col = colour)
  lines(tt, qpois(p = probq_vals[2], lambda = tt * lmb_scaled),
        lwd = 2, lty = 4, col = colour)
  lines(tt, qpois(p = probq_vals[4], lambda = tt * lmb_scaled),
        lwd = 2, lty = 4, col = colour)
  lines(tt, qpois(p = probq_vals[5], lambda = tt * lmb_scaled),
        lwd = 2, lty = 3, col = colour)
  
  
  
}



create_summary_graph_C <- function(){
  
  par(mfrow = c(1, 1))
  
  x_max <- 1.25 * T_target()
  y_max <- qpois(p=0.999, lambda = T_target() * lmb()) + 5 * sqrt(T_target() * lmb())
  y_max <- max(qpois(p=0.999, lambda = T_target() * lmb_scaled()),
               qpois(p=0.999, lambda = T_target() * lmb()) )
  
  
  create_cumcount_gridplot(C_target = T_target() * lmb(), T_target = T_target(), 
                           time_unit = time_unit(), subject_unit = count_unit(), 
                           time_name = time_name(), subject_name = count_unit(),
                           x_max = x_max,  y_max = y_max )
  
  
  create_cumcount_c_base(T_target = T_target(), lmb = lmb(), probq_vals = probq_vals)
  
  create_cumcount_c_scaled(T_target = T_target(), lmb_scaled = lmb_scaled(),
                           probq_vals = probq_vals, colour = C_color)
  
  
  #Adding line for objective 
  abline(v = T_target(), col = "black", lwd = 1, lty = 2)
  
  legend(
    "topleft",
    
    legend = c(expression(paste("Scaled ", lambda,
                                ": central 95%")), 
               expression(paste("Scaled ", lambda,
                                ": central 50%"))
    ),
    lty = c(3, 4),
    col = c(C_color, C_color),
    bg = "white",
    cex = 1,
    bty = "n"
  )
  
  
}



##
## Accrual for time -------------------------------------------------------------
##


create_summary_graph_T <- function(){
  
  
  par(mfrow = c(1, 1))
  
  x_max <- 1.25 * C_target() / lmb()
  y_max <- qpois(p=0.999, lambda = C_target()) + 5 * sqrt(C_target())
  y_max <- max(qpois(p=0.999, lambda = C_target() * ff()),
               qpois(p=0.999, lambda = C_target()) )
  
  
  create_cumcount_gridplot(C_target = C_target(), T_target = C_target() / lmb(), 
                           time_unit = time_unit(), subject_unit = count_unit(), 
                           time_name = time_name(), subject_name = count_unit(),
                           x_max = x_max,  y_max = y_max )
  
  
  create_cumcount_c_base(T_target = C_target() / lmb(), lmb = lmb(), probq_vals = probq_vals)
  
  create_cumcount_c_scaled(T_target = C_target() / lmb(), lmb_scaled = lmb_scaled(),
                           probq_vals = probq_vals, colour = T_color)
  
  
  #Adding line for objective 
  abline(h = C_target(), col = "black", lwd = 1, lty = 2)
  
  legend(
    "topleft",
    
    legend = c(expression(paste("Scaled ", lambda,
                                ": central 95%")), 
               expression(paste("Scaled ", lambda,
                                ": central 50%"))
    ),
    lty = c(3, 4),
    col = c(T_color, T_color),
    bg = "white",
    cex = 1,
    bty = "n"
  )
  
}

##
## Output function Accrual -----------------------------------------------------
##

summary_plot_output <- function(input, output){
  
  output$sum_plot <- renderPlot({
    
    if(pred_mode() == "recruitment counts") {
      if(is.numeric(T_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() > 0 &
         buf_T_target() > 0 & buf_ff() > 0){
        create_summary_graph_C()
      } else {
        empty_plot()
      }
    } else {
      if(is.numeric(C_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() > 0 &
         buf_C_target() > 0 & buf_ff() > 0){
        create_summary_graph_T()
      } else {
        empty_plot()
      }
    }
    
    
  })
  
  
}



##
## 3. interpretation text ########################################################
##


##
## Generate quantile table -----------------------------------------------------
##



summary_text <- function(input,output){
  
  # Expected value for scaled lmb
  C_exp_scaled <- reactive(T_target() * lmb_scaled())
  output$expected_C <- renderText(round(C_exp_scaled(), 0))
  
  # Quantile table for the scaled recruitment rate:
  # Compute the quantiles of counts for different fractions of T_target and
  # store them in a dataframe (one column for each fraction of T_target)
  quantiles_C_scaled <- reactive(t(data.frame(
    Counts = c(round(qpois(p = probq_vals, lambda = T_target() * lmb_scaled()), 0
    )))))
  
  quantiles_T_scaled <- reactive({
    if (time_unit() == "month" | time_unit() == "year") {
      t(data.frame(
        Time = c(round(qgamma(p = probq_vals, shape = C_target(), rate = lmb_scaled()), 2
        ))))
    } else {
      t(data.frame(
        Time = c(round(qgamma(p = probq_vals, shape = C_target(), rate = lmb_scaled()), 1
        )))) }
  })
  
  
  #C_tab with coloured output
  
  C_tab <<- function(){
    C_tab <- quantiles_C_scaled()
    colnames(C_tab) <- c(probq_lab)
    
    C_tab  %>%
      kableExtra::kable("html") %>%
      kable_styling(bootstrap_options = "bordered", full_width = F, position = "center") %>%
      row_spec(0, background = "lightgray") %>%
      column_spec(3, color = "coral1", bold = T) %>%
      column_spec(5, color = "darkgoldenrod1", bold = T)
  }
  
  #T_tab with coloured output
  
  T_tab <<- function(){
    T_tab <- quantiles_T_scaled()
    colnames(T_tab) <- c(probq_lab)
    
    T_tab %>%
      kableExtra::kable("html") %>%
      kable_styling(bootstrap_options = "bordered", full_width = F, position = "center") %>%
      row_spec(0, background = "lightgray") %>%
      column_spec(3, color = "aquamarine3", bold = T) %>%
      column_spec(5, color = "cornflowerblue", bold = T) 
    
  }
  
  
  ##
  ## Generate text for C and T --------------------------------------------------  
  ## 
  
  sum_text_C <<- function(){
    
    tagList(
      #tags$div(style = "height:-10px"),
      p("This is a prediction of counts based on a scaled recruitment rate of", round(lmb_scaled(),3), count_units(), "per", time_unit(),
        "and T", tags$sub("target"), "of", T_target(), paste0(time_units(), "."),
        style = "margin-top:-20px ; font-size:85%"),
      
      p(tags$b("Out of 100 studies like the planned one, we expect the following:"), 
        style = "font-size:85% ; padding :0"),
      
      p(tags$ul(tags$li(probq_vals[2]*100, "studies will", tags$b("not"), "be able to recruit more than ",
                        tags$b(quantiles_C_scaled()[1,2], style = "color:#e57248") , count_units(),  style = "font-size:85% ; margin-top:-20px ; padding: 0"),
                
                tags$li(100 - probq_vals[2]*100, "studies will successfully recruit more than", tags$b( quantiles_C_scaled()[1,2], style = "color:#e57248") , count_units(),
                        style = "font-size:85%"),
                
                tags$li(probq_vals[3]*100, "studies will recruit between", tags$b(quantiles_C_scaled()[1,2], style = "color:#e57248"), "and",
                        tags$b(quantiles_C_scaled()[1,4], style = "color:#FFB90E"), count_units(), style = "font-size:85%")
                
      )),
      
      
      p("Under these conditions, the expected recruitment count achieved is", paste0(quantiles_C_scaled()[1,3],"."), 
        style = "font-size:85% ; margin-top:-30px ; padding: 0")
    )
    
  }
  
  
  
  sum_text_T <<- function(){
    
    tagList(
      #tags$div(style = "height:-10px"),
      p("This is a prediction of time based on a scaled recruitment rate of", round(lmb_scaled(),3), count_units(), "per", time_unit(),
        "and C", tags$sub("target"), "of", C_target(), paste0(count_units(), "."),
        style = "font-size:85%; margin-top:-20px"),
      
      p(tags$b("Out of 100 studies like the planned one, we expect the following:"), 
        style = "font-size:85% ; padding :0"),
      
      p(tags$ul(tags$li(probq_vals[2]*100, "studies will", tags$b("not"), "be able to recruit more than ",
                        C_target(), count_units(), "within", tags$b(quantiles_T_scaled()[1,4], style = "color:#6495ed"), time_units(),
                        style = "font-size:85% ; margin-top:-20px ; padding: 0"),
                
                tags$li(100 - probq_vals[2]*100, "studies will successfully recruit more than",
                        C_target(), count_units(), "within", tags$b(quantiles_T_scaled()[1,4], style = "color:#6495ed"), time_units(),
                        style = "font-size:85%"),
                
                tags$li(probq_vals[3]*100, "studies will recruit", C_target(), count_units(), "between", tags$b(quantiles_T_scaled()[1,2], style = "color:#66ceab"), "and",
                        tags$b(quantiles_T_scaled()[1,4], style = "color:#6495ed"), time_units(), "of time", style = "font-size:85%")
                
      )),
      
      p("Under these conditions, the expected recruitment time is", round(C_target() / lmb_scaled(), 1), paste0( time_units() ,"."),
        style = "font-size:85% ; margin-top:-30px ; padding: 0")
    )
    
  }
  
  
  
}




##
## Output function for text and tables -----------------------------------------  
## 


summary_text_choice <- function(input, output){
  
  output$sum_text <- renderUI({
    
    if(pred_mode() == "recruitment counts") {
      if(is.numeric(T_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() > 0
         & buf_T_target() > 0 & buf_ff() > 0){
        sum_text_C()
      } else {
        p(tags$b("Please enter a value in all input fields to create
          an output"))
      }
    } else {
      if(is.numeric(C_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() > 0
         & buf_C_target() > 0 & buf_ff() > 0){
        sum_text_T()
      } else {
        p(tags$b("Please enter a value in all input fields to create
          an output"))
      }
    }
    
  })
} 

summary_quantile_choice <- function(input, output){
  
  output$sum_quant <- reactive({
    
    if(pred_mode() == "recruitment counts") {
      if(is.numeric(T_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() > 0 &
         buf_T_target() > 0 & buf_ff() > 0) {
        C_tab()
      } else {}
    } else {
      if(is.numeric(C_target()) & is.numeric(lmb()) & count_unit() != "" & lmb() > 0 &
         buf_C_target() > 0 & buf_ff() > 0){
        T_tab()
      } else {}
    }
    
  })
} 


###############################
## Server - helper functions  #########################################################
###############################
#
# This section contains extra server elements that accomplish tasks for all the tabs
# They are saved separately as they do not quite fit anywhere else.
# 



##
## Automatic switching of tabs
##

switch_tab_info_buttons <- function(input,output){
  observeEvent(input$time_scale_1, {
    req()
    updateNavbarPage(
      inputId = "tabs",  
      selected = "scaling")
    updateSelectInput(
      inputId = "mode_switch",
      selected = "recruitment time")
  }) 
  
  observeEvent(input$count_scale_1, {
    updateNavbarPage(
      inputId = "tabs",  
      selected = "scaling")
    updateSelectInput(
      inputId = "mode_switch",
      selected = "recruitment counts")
  })
  
  
  
  observeEvent(input$time_scale_4, {
    updateNavbarPage(
      inputId = "tabs",  
      selected = "converting")
    updateSelectInput(
      inputId = "mode_switch",
      selected = "recruitment time")
  }) 
  
  observeEvent(input$count_scale_4, {
    updateNavbarPage(
      inputId = "tabs",  
      selected = "converting")
    updateSelectInput(
      inputId = "mode_switch",
      selected = "recruitment counts")
  })
  
  
  
}


##
## Slider for scaling factor --------------------------------------------------
##

slider_ff_UI <- function(input, output){
  
  output$slider_ff <- renderUI({
    
    if(is.numeric(lmb())){
      
      layout_columns(
        
        if(buf_ff() <= 2 & buf_ff() >= 0){
          sliderInput("scale_ff", label = p("Scaling factor", tags$i("f", style = "font-family:'Calibri'")),
                      min = 0, max = 2, value = round(buf_ff(),4), ticks = T,
                      width = "400px", step = 0.0001)
        } else {p()},
        
        numericInput("scale_ff_num", label = p("Value", tags$i("f", style = "font-family:'Calibri'")),
                     min = 0, max = 30,
                     value = round(buf_ff(),4), step = 0.0001, 
                     width = "200px"), 
        
        col_widths = c(9,3)
      )
      
    } else {
      p(" ")
    }
    
  })
  
}



##
## Slider for lambda -----------------------------------------------------------
##

slider_UI <- function(input, output){
  
  output$slider_lambda <- renderUI({
    
    if(is.numeric(lmb())){
      
      layout_columns(
        
        if(buf_ff() <= 2 & buf_ff() >= 0 ){
          sliderInput("slide_lambda",
                      label = p("Scaled recruitment rate", "\u03bb", tags$sub("scaled")),
                      min = round(0*lmb(),2) , max = 2*lmb(),
                      value = round(buf_ff()*lmb(), 5), ticks = FALSE, step = 0.00001,
                      width = "400px")
        } else {  p(tags$i("Sliders only supported between f = 0 and f = 2"))},
        
        numericInput("slide_lmb_numeric", p("Value", "\u03bb", tags$sub("scaled")),
                     min = round(0*lmb(),2), max = round(30*lmb(),2),
                     value = round(buf_ff()*lmb(), 5), step = 0.00001,
                     width = "200px"),
        
        col_widths = c(9,3)
        
      )
    } else {
      p(" ")
    }
    
  })
  
}


##
## Screenshot function --------------------------------------------------------
##


screenshots <- function(input, output){
  
  observeEvent(input$save_scaling, {
    screenshot(filename = "recruitment_scaling",
               scale = 2)
  })
  
  
  observeEvent(input$save, {
    screenshot(filename = "recruitment_converting",
               scale = 2)
  })
  
  
}



##
## Conversion table ------------------------------------------------------------
##

table_choice <- function(input,output){
  
  output$conv_table <- renderUI({
    div(img( src= named(), style = "height:200px", allign = "center"))
  })  
  
  named <- reactive({
    if (time_unit() == "day") {
      if (new_time() == "day") {
        "converting/dayday.png"
      } else if (new_time() == "week") {
        "converting/dayweek.png"
      } else if (new_time() == "month") {
        "converting/daymonth.png"
      } else if (new_time() == "year"){
        "converting/dayyear.png"
      }
      
    } else if (time_unit() == "week") {
      if (new_time() == "day") {
        "converting/weekday.png"
      } else if (new_time() == "week") {
        "converting/weekweek.png"
      } else if (new_time() == "month") {
        "converting/weekmonth.png"
      } else if (new_time() == "year"){
        "converting/weekyear.png"
      }
      
    } else if (time_unit() == "month"){
      if (new_time() == "day") {
        "converting/monthday.png"
      } else if (new_time() == "week") {
        "converting/monthweek.png"
      } else if (new_time() == "month") {
        "converting/monthmonth.png"
      } else if (new_time() == "year"){
        "converting/monthyear.png"
      }
      
    } else if (time_unit() == "year"){
      if (new_time() == "day") {
        "converting/yearday.png"
      } else if (new_time() == "week") {
        "converting/yearweek.png"
      } else if (new_time() == "month") {
        "converting/yearmonth.png"
      } else if (new_time() == "year"){
        "converting/yearyear.png"
      }
    }
  })
  
}


##
## Create empty plot -----------------------------------------------------------
##

empty_plot <- function(){
  
  par(mar = c(1,1,1,1))
  
  plot(c(0,1), c(0,1), ann = F, type = 'n', xaxt = 'n', yaxt = 'n')
  
  text(x = 0.5, y = 0.5, paste("Please enter a value in all \n",
                               "input fields to create\n",
                               "a plot."), 
       cex = 1.3, col = "black")
}

##
## Create arrow plot -----------------------------------------------------------
##

arrow <<- function(){
  
  plot(c(0,1), c(0,1), ann = F, type = 'n', xaxt = 'n', yaxt = 'n',
       bty = "n")
  arrows(0.15,0.5,0.85,.5, lwd = 5)
  
}



###############################
## Server - converting units  ##################################################
###############################
#
# This section contains the functions necessary for the converting time units
# tab, they are seperated in three sections:
# - Distribution plots
# - Accrual plots
# - Summary text



##
## 1. Distribution plots #######################################################
##

##
## time plots ----------------------------------------------------------------
##


# cumulative distribution function

time_cumulative_ex4 <- function(C_target = C_target,
                                lmb = lmb,
                                colour = T_color, time_unit = time_unit,
                                title_main, title_legend){
  
  
  #Scale
  t_xxl <<- qgamma(p = 0.001, shape = C_target, rate = lmb)
  t_xxu <<- qgamma(p = 0.999, shape = C_target, rate = lmb)
  
  # Create a grid of 10^4 values & compute the cumulative probability
  # at these values
  grid <- seq(from = t_xxl, to = t_xxu, length.out = 10^4)
  pgvec_original <- pgamma(q = grid, shape = C_target, rate = lmb) * 100
  plot(
    x = grid,
    y = pgvec_original,
    xlab = paste0("Time (", time_unit, "s)"),
    ylab = "Cumulative Probability Function",
    yaxt = "n",
    type = "n",
    main = title_main,
    las = 1,
    cex.lab = 0.95,
    cex.axis = 0.9
  )
  
  # Plot the cumulative probability functions for original and scaled lmb
  lines(grid, pgvec_original, col = T_color, type = "l", lwd = 2)
  
  # Add lines and labels for confidence values
  axis(2, at = cpf_vals, col.ticks = "black", labels = cpf_lab,
       cex.axis = 0.9, las = 1)
  
  abline(h = probq_vals[c(1,3,5)] * 100, col = "gray30", lwd = 1.2, lty = 2)
  abline(h = probq_vals[2] * 100, col = "aquamarine3", lwd = 1.2, lty = 2)
  abline(h = probq_vals[4] * 100, col = "cornflowerblue", lwd = 1.2, lty = 2)
  
}



# probability density function


time_density_ex4 <- function(C_target = C_target,
                             lmb = lmb,
                             colour = T_color, time_unit = time_unit,
                             title_main, title_legend){
  
  t_xxl <-  qgamma(p = 0.001, shape = C_target, rate = lmb) 
  t_xxu <-  qgamma(p = 0.999, shape = C_target, rate = lmb)
  
  
  t_yyl <- max(dgamma(
    x = seq(from = t_xxl, to = t_xxu, length.out = 10000),
    shape = C_target,
    rate = lmb))
  
  # Plot the density for original recruitment rate lmb
  curve(
    dgamma(x, shape = C_target, rate = lmb),
    from = t_xxl,
    to = t_xxu,
    ylim = c(0, t_yyl),
    type = "l",
    col = colour,
    lty = 1,
    lwd = 2,
    xlab = paste0("Time (", time_unit, "s)"),
    ylab = "Density",
    main = title_main,
    las = 1,
    cex.lab = 0.95,
    cex.axis = 0.9,
  )
  
}


##
## Count plots ----------------------------------------------------------------
##

# cumulative distribution function

count_cum_ex4 <- function(lmb, T_target, C_color, subject_unit, title_main, title_legend){
  
  c_xxl <- qpois(p = 0.001, lambda = T_target * lmb)
  
  c_xxu <- qpois(p = 0.999, lambda = T_target * lmb)
  
  
  plot(
    x = c(c_xxl:c_xxu),
    y = ppois(q = c(c_xxl:c_xxu), lambda = T_target * lmb) * 100,
    main = title_main,
    xlab = paste0("Count (", subject_unit, ")"),
    ylab = "Cumulative Probability Function",
    type = "s",
    col = C_color,
    lwd = 2,
    las = 1,
    lty = 1,
    yaxt = "n",
    cex.lab = 0.95,
    cex.axis = 0.9
  )
  
  
  # Add tick marks and lines at the probability values in cpf_vals
  axis(2, at = cpf_vals, col.ticks = "black", labels = cpf_lab,
       cex.axis = 0.9, las = 1)
  abline(h = probq_vals[c(1,3,5)] * 100, col = "gray30", lwd = 1.2, lty = 2)
  abline(h = probq_vals[2] * 100, col = "coral1", lwd = 1.2, lty = 2)
  abline(h = probq_vals[4] * 100, col = "darkgoldenrod1", lwd = 1.2, lty = 2)
  
}

# Probability mass function

count_pmf_plot_ex4 <- function(lmb, T_target, C_color,
                               subject_unit, title_main, title_legend){
  
  
  c_xxl <- qpois(p = 0.001, lambda = T_target * lmb)
  
  c_xxu <- qpois(p = 0.999, lambda = T_target * lmb)
  
  c_xx <- c(c_xxl:c_xxu)
  
  c_yyl <- max(dpois(x = c_xx, lambda = T_target * lmb))
  
  
  
  
  plot(
    x = c_xx,
    y = dpois(x = c_xx, lambda = T_target * lmb),
    type = "n",
    ylim = c(0, c_yyl),
    xlab = paste0("Count (", subject_unit, ")"),
    ylab = "Probability Mass Function",
    main = title_main,
    las = 1,
    cex.lab = 0.95,
    cex.axis = 0.9
  )
  
  # Plot the probability mass function for original lmb
  lines(
    c_xx,
    dpois(x = c_xx, lambda = T_target * lmb),
    type = "s",
    col = C_color,
    lwd = 2,
    lty = 1
  )
  
  
}


##
## Output functions converting tab ---------------------------------------------
##


distr_plot_ex_4 <- function(input, output){
  
  output$distr_plot_pdf_ex4 <- renderPlot({
    
    par(mar = c(4,4,2,3), mfrow = c(1,2))
    
    if (pred_mode() == "recruitment counts") {
      if(is.numeric(T_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0 &
         buf_T_target() > 0){
        
        count_pmf_plot_ex4(T_target = T_target(), 
                           lmb = lmb(),
                           C_color = C_color, subject_unit = buf_C_unit(),
                           title_main = "Original time unit",
                           title_legend = "Original"
        )
        
        count_pmf_plot_ex4(T_target = T_target(), 
                           lmb = lmb(),
                           C_color = C_color, subject_unit = buf_C_unit(),
                           title_main = "Converted time unit",
                           title_legend = "Converted"
        )
      } else {
        empty_plot()
        empty_plot()
      }
      
    } else {
      if(is.numeric(C_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0 &
         buf_C_target() > 0){
        
        time_density_ex4(C_target = C_target(),
                         lmb = lmb(), 
                         colour = T_color,
                         time_unit = time_unit(),
                         title_main = "Original time unit",
                         title_legend = "Original"
        )
        
        
        time_density_ex4(C_target = C_target(),
                         lmb = lmb_converted(), 
                         colour = T_color,
                         time_unit = new_time(),
                         title_main = "Converted time unit",
                         title_legend = "Converted"
        )
      } else {
        empty_plot()
        empty_plot()
      }
      
      
    }
    
    
  })
  
  
  
  
  
  
  output$distr_plot_cdf_ex4 <- renderPlot({
    
    
    par(mar = c(4,4,2,3), mfrow = c(1,2))
    
    
    if (pred_mode() == "recruitment counts") {
      if(is.numeric(T_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0 &
         buf_T_target() > 0){
        
        count_cum_ex4(T_target = T_target(),
                      lmb = lmb(), 
                      C_color = C_color, subject_unit = buf_C_unit(),
                      title_main = "Original time unit",
                      title_legend = "Original"
        )
        
        count_cum_ex4(T_target = T_target(),
                      lmb = lmb(), 
                      C_color = C_color, subject_unit = buf_C_unit(),
                      title_main = "Converted time unit",
                      title_legend = "Converted"
        )
        
      } else {
        empty_plot()
        empty_plot()
      } 
      
    } else {
      
      if(is.numeric(C_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0 &
         C_target() > 0){
        
        time_cumulative_ex4(C_target = C_target(),
                            lmb = lmb(),
                            colour = T_color, time_unit = time_unit(),
                            title_main = "Original time unit",
                            title_legend = "Original"
        )
        
        time_cumulative_ex4(C_target = C_target(),
                            lmb = lmb_converted(),
                            colour = T_color, time_unit = new_time(),
                            title_main = "Converted time unit",
                            title_legend = "Converted"
        )
        
      } else {
        empty_plot()
        empty_plot()}
      
      
    }
    
  })         
  
}


##
## 2. Accrual plots #######################################################
##

##
## background grid -------------------------------------------------------------
##

create_cumcount_gridplot_4 <<- function(C_target = C_target, 
                                        T_target = T_target, 
                                        time_unit = time_unit, 
                                        subject_unit = subject_unit, 
                                        time_name = time_name, 
                                        subject_name = subject_name,
                                        x_max = x_max,
                                        y_max = y_max,
                                        text_main) {
  
  plot(
    NA,
    NA,
    ylim = c(0, y_max), #1.25 *Ctarget
    xlim = c(0, x_max), #1.25 *ttarget
    xaxs = "i",
    yaxs = "i",
    xlab = paste0("Time (", time_unit, "s)"),
    ylab = paste0("Cumulative count (", subject_unit, ")"),
    las = 1,
    cex.lab = 1,
    cex.axis = 1,
    main = text_main
  )
  
  frac_labs <- c("", "3 / 2")
  frac_vals <- c(2 / 2, 3/ 2)
  
  #Adding vertical and horizontal thin grid
  
  
  for (i in 1:length(frac_labs)) {
    # Add tick marks and labels for time on top
    #T_tick_lab <- bquote(atop(.(bquote(.(frac_labs[i]) ~ T[target])), "(" ~ .(round((frac_vals[i] * T_target), 1)) ~ .(time_name) ~ ")"))
    T_tick_lab <- bquote(.(bquote(.(frac_labs[i]) ~ T[target])))
    axis(3, at = frac_vals[i] * T_target, col.ticks = "black", labels = T_tick_lab, cex.axis = 0.9)
    
    abline(v = frac_vals[i] * T_target, col = "dimgray", lty = 2, lwd = 0.5)
    
    # Add tick marks and labels for counts on the right
    #C_tick_lab <- bquote(atop(.(bquote(.(frac_labs[i]) ~ C[target])), "(" ~ .(ceiling(frac_vals[i] * C_target)) ~ .(subject_name) ~ ")"))
    C_tick_lab <- bquote(.(bquote(.(frac_labs[i]) ~ C[target])))
    axis(4, at = frac_vals[i] * C_target, col.ticks = "black", labels = C_tick_lab, las = 1, cex.axis = 0.9)
    abline(h = frac_vals[i] * C_target, col = "dimgray", lty = 2, lwd = 0.5)
    
  }
}


##
## Accrual for Counts -------------------------------------------------------------
##

create_cumcount_c_base <<- function(T_target, lmb, probq_vals){
  
  # tt <- c(0:ceiling(1.5 * T_target))
  tt <- seq(0, 1.5*T_target, length.out = 10)
  
  polygon_cols <- c("lightgray", "darkgray", "lightgray")
  
  qline1 <- qpois(probq_vals[1], lmb * tt)
  qline2 <- qpois(probq_vals[2], lmb * tt)
  qline3 <- qpois(probq_vals[4], lmb * tt)
  qline4 <- qpois(probq_vals[5], lmb * tt)
  
  polygon(c(tt, rev(tt)),
          c(qline1, rev(qline2)),
          col = polygon_cols[1],
          border = NA)
  
  polygon(c(tt, rev(tt)),
          c(qline2, rev(qline3)),
          col = polygon_cols[2],
          border = NA)
  
  polygon(c(tt, rev(tt)),
          c(qline3, rev(qline4)),
          col = polygon_cols[3],
          border = NA)
}


create_summary_graph_C_4_base <- function(){
  
  x_max <- 1.25 * T_target()
  y_max <- qpois(p=0.999, lambda = T_target() * lmb()) + 5 * sqrt(T_target() * lmb())
  y_max <- max(qpois(p=0.999, lambda = T_target() * lmb()),
               qpois(p=0.999, lambda = T_target() * lmb()) )
  
  
  create_cumcount_gridplot_4(C_target = T_target() * lmb(), T_target = T_target(), 
                             time_unit = time_unit(), subject_unit = buf_C_unit(), 
                             time_name = time_name(), subject_name = buf_C_unit(),
                             x_max = x_max,  y_max = y_max, text_main = "Original time unit" )
  
  
  create_cumcount_c_base(T_target = T_target(), lmb = lmb(), probq_vals = probq_vals)
  
  
  
  #Adding line for objective 
  abline(v = T_target(), col = "black", lwd = 1, lty = 2)
  
}



create_summary_graph_C_4_converted <- function(){
  
  # Weird formulation with * lmb and divided by lmb_converted but it is to avoid
  # having to write the 16 if statements a 3rd time
  x_max <- 1.25 * T_target() * lmb() / lmb_converted()
  y_max <- qpois(p=0.999, lambda = T_target() * lmb()) + 5 * sqrt(T_target() * lmb())
  y_max <- max(qpois(p=0.999, lambda = T_target() * lmb()),
               qpois(p=0.999, lambda = T_target() * lmb()) )
  
  
  create_cumcount_gridplot_4(C_target = T_target() * lmb(), T_target = T_target() * lmb() / lmb_converted(), 
                             time_unit = new_time(), subject_unit = buf_C_unit(), 
                             time_name = paste0(new_time(),"s"), subject_name = buf_C_unit(),
                             x_max = x_max,  y_max = y_max, text_main = "Converted time unit" )
  
  
  create_cumcount_c_base(T_target = T_target() * lmb() / lmb_converted(), lmb = lmb_converted(), probq_vals = probq_vals)
  
  #Adding line for objective 
  abline(v = T_target() * lmb() / lmb_converted(), col = "black", lwd = 1, lty = 2)
  
}




##
## Accrual for time -------------------------------------------------------------
##


create_summary_graph_T_4_base <- function(){
  
  x_max <- 1.25 * C_target() / lmb()
  y_max <- qpois(p=0.999, lambda = C_target()) + 5 * sqrt(C_target())
  y_max <- max(qpois(p=0.999, lambda = C_target() ),
               qpois(p=0.999, lambda = C_target()) )
  
  
  create_cumcount_gridplot_4(C_target = C_target(), T_target = C_target() / lmb(), 
                             time_unit = time_unit(), subject_unit = buf_C_unit(), 
                             time_name = time_name(), subject_name = buf_C_unit(),
                             x_max = x_max,  y_max = y_max, text_main = "Original time unit")
  
  
  create_cumcount_c_base(T_target = C_target() / lmb(), lmb = lmb(), probq_vals = probq_vals)
  
  
  
  #Adding line for objective 
  abline(h = C_target(), col = "black", lwd = 1, lty = 2)
  
}



create_summary_graph_T_4_converted <- function(){
  
  x_max <- 1.25 * C_target() / lmb_converted()
  y_max <- qpois(p=0.999, lambda = C_target()) + 5 * sqrt(C_target())
  y_max <- max(qpois(p=0.999, lambda = C_target()  ),
               qpois(p=0.999, lambda = C_target()) )
  
  
  create_cumcount_gridplot_4(C_target = C_target(), T_target = C_target() / lmb_converted(), 
                             time_unit = new_time(), subject_unit = buf_C_unit(), 
                             time_name = time_name(), subject_name = buf_C_unit(),
                             x_max = x_max,  y_max = y_max, text_main = "Converted time unit" )
  
  
  create_cumcount_c_base(T_target = C_target() / lmb_converted(), lmb = lmb_converted(), probq_vals = probq_vals)
  
  
  
  #Adding line for objective 
  abline(h = C_target(), col = "black", lwd = 1, lty = 2)
  
}


##
## Output function Accrual -----------------------------------------------------
##


summary_plot_output_4_base <- function(input, output){
  
  output$sum_plot_4_base <- renderPlot({
    
    if(pred_mode() == "recruitment counts") {
      if(is.numeric(T_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0 &
         buf_T_target() > 0){
        par(mfrow = c(1,2), mar = c(4, 4, 6, 5))
        create_summary_graph_C_4_base()
        par(mar = c(4,4.5,6,4.5))
        create_summary_graph_C_4_converted()
      } else {
        empty_plot()
      }
    } else {
      if(is.numeric(C_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0 &
         buf_C_target() > 0){
        par(mfrow = c(1,2), mar = c(4, 4, 6, 5))
        create_summary_graph_T_4_base()
        par(mar = c(4,4.5,6,4.5))
        create_summary_graph_T_4_converted()
      } else {
        empty_plot()
      }
    }
    
    
    
  })
  
  
}

##
## 3. interpretation text ########################################################
##


##
## Generate quantile table -----------------------------------------------------
##

summary_text_4 <- function(input,output){
  
  # Expected value for scaled ll
  C_exp_4 <- reactive(T_target() * lmb_converted())
  output$expected_C <- renderText(round(C_exp_4(), 0))
  
  # Quantile table for the scaled recruitment rate:
  # Compute the quantiles of counts for different fractions of T_target and
  # store them in a dataframe (one column for each fraction of T_target)
  quantiles_C_scaled_4 <- reactive(t(data.frame(
    Counts = c(round(qpois(p = probq_vals, lambda = T_target() * lmb()), 0
    )))))
  
  quantiles_T_scaled_4 <- reactive({
    
    if (new_time() == "month" | new_time() == "year") {
      t(data.frame(
        Time = c(round(qgamma(p = probq_vals, shape = C_target(), rate = lmb_converted()), 2
        ))))
    } else {  
      t(data.frame(
        Time = c(round(qgamma(p = probq_vals, shape = C_target(), rate = lmb_converted()), 1
        ))))
    }
    
  })
  
  
  C_tab_4 <<- function(){
    C_tab_4 <- quantiles_C_scaled_4()
    colnames(C_tab_4) <- c(probq_lab)
    
    
    
    C_tab_4  %>%
      knitr::kable("html")  %>%
      kable_styling(bootstrap_options = "bordered", full_width = F, position = "center") %>%
      row_spec(0, background = "lightgray") %>%
      column_spec(3, color = "coral1", bold = T) %>%
      column_spec(5, color = "darkgoldenrod1", bold = T)
  }
  
  T_tab_4 <<- function(){
    T_tab <- quantiles_T_scaled_4()
    colnames(T_tab) <- c(probq_lab)
    T_tab %>%
      kableExtra::kable("html") %>%
      kable_styling(bootstrap_options = "bordered", full_width = F, position = "center") %>%
      row_spec(0, background = "lightgray") %>%
      column_spec(3, color = "aquamarine3", bold = T) %>%
      column_spec(5, color = "cornflowerblue", bold = T)
  }
  
  ##
  ## Generate text for C and T --------------------------------------------------  
  ## 
  
  
  sum_text_C_4 <<- function(){
    
    tagList(
      #tags$div(style = "height:-10px"),
      p("This is a prediction of counts based on a scaled recruitment rate of", round(lmb_converted(),3), paste0(buf_C_unit()), "per", new_time(),
        "and T", tags$sub("target"), "of", round(T_target()*lmb()/lmb_converted(), 1), paste0(new_times(), "."),
        style = "margin-top:-20px ; font-size:85%"),
      
      p(tags$b("Out of 100 studies like the planned one, we expect the following:"), 
        style = "font-size:85% ; padding :0"),
      
      p(tags$ul(tags$li(probq_vals[2]*100, "studies will", tags$b("not"), "be able to recruit more than ",
                        tags$b(quantiles_C_scaled_4()[1,2], style = "color:#e57248") , paste0(buf_C_unit()),  style = "font-size:85% ; margin-top:-20px ; padding: 0"),
                
                tags$li(100 - probq_vals[2]*100, "studies will successfully recruit more than", tags$b( quantiles_C_scaled_4()[1,2], style = "color:#e57248") , paste0(buf_C_unit()),
                        style = "font-size:85%"),
                
                tags$li(probq_vals[3]*100, "studies will recruit between", tags$b(quantiles_C_scaled_4()[1,2], style = "color:#e57248"), "and",
                        tags$b(quantiles_C_scaled_4()[1,4], style = "color:#FFB90E"), paste0(buf_C_unit()), style = "font-size:85%")
                
      )),
      
      
      p("Under these conditions, the expected recruitment count achieved is", paste0(quantiles_C_scaled_4()[1,3],"."), 
        style = "font-size:85% ; margin-top:-30px ; padding: 0")
    )
    
  }
  
  
  
  sum_text_T_4 <<- function(){
    
    tagList(
      #tags$div(style = "height:-10px"),
      p("This is a prediction of time based on a scaled recruitment rate of", round(lmb_converted(),3), paste0(buf_C_unit()), "per", new_times(),
        "and C", tags$sub("target"), "of", C_target(), paste0(paste0(buf_C_unit()), "."),
        style = "font-size:85%; margin-top:-20px"),
      
      p(tags$b("Out of 100 studies like the planned one, we expect the following:"), 
        style = "font-size:85% ; padding :0"),
      
      p(tags$ul(tags$li(probq_vals[2]*100, "studies will", tags$b("not"), "be able to recruit more than ",
                        C_target(), paste0(buf_C_unit()), "within", tags$b(quantiles_T_scaled_4()[1,4], style = "color:#6495ed"), new_times(),
                        style = "font-size:85% ; margin-top:-20px ; padding: 0"),
                
                tags$li(100 - probq_vals[2]*100, "studies will successfully recruit more than",
                        C_target(), paste0(buf_C_unit()), "within", tags$b(quantiles_T_scaled_4()[1,4], style = "color:#6495ed"), new_times(),
                        style = "font-size:85%"),
                
                tags$li(probq_vals[3]*100, "studies will recruit", C_target(), paste0(buf_C_unit()), "between", tags$b(quantiles_T_scaled_4()[1,2], style = "color:#66ceab"), "and",
                        tags$b(quantiles_T_scaled_4()[1,4], style = "color:#6495ed"), new_times(), "of time", style = "font-size:85%")
                
      )),
      
      p("Under these conditions, the expected recruitment time is", round(C_target() / lmb_converted(), 1), paste0(new_times() ,"."),
        style = "font-size:85% ; margin-top:-30px ; padding: 0")
    )
    
  }
  
  
}


##
## Output function for text and tables -----------------------------------------  
## 

summary_text_choice_4 <- function(input, output){
  
  output$sum_text_4 <- renderUI({
    
    if(buf_pred_mode() == "recruitment counts") {
      if(is.numeric(T_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0
         & buf_T_target() > 0){
        sum_text_C_4()
      } else {
        p(tags$b("Please enter a value in all input fields to create
          an output"))
      }
    } else {
      if(is.numeric(C_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0
         & buf_C_target() > 0){
        sum_text_T_4()
      } else {
        p(tags$b("Please enter a value in all input fields to create
          an output"))
      }
    }
    
  })
} 

summary_quantile_choice_4 <- function(input, output){
  
  output$sum_quant_4 <- reactive({
    
    if(buf_pred_mode() == "recruitment counts") {
      if(is.numeric(T_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0 &
         buf_T_target() > 0){
        C_tab_4()
      } else {}
    } else {
      if(is.numeric(C_target()) & is.numeric(lmb()) & buf_C_unit() != "" & lmb() > 0 &
         buf_C_target() > 0){
        T_tab_4()
      } else {}
    }
    
  })
}




##
## App and layout
##


# Defines UI layout
ui <- fluidPage(
     
    theme = bs_theme(bootswatch = "cerulean"),  
  
    # Application title
    titlePanel(windowTitle = "RECAN-scaling",
               
                fluidRow(
                  tags$div(style = "height:10px"),
                  column(9, div(img( src = "recan_logo.png", style = "height:45px"))),
                  column(3,)
                )
    ),
    
    navset_tab( id = "tabs",
                
      nav_panel("Information", 
        introduction(),
        
        layout_columns(
        
            card(card_header(tags$h3("Scaling of recruitment rate")),
            scaling_rate_card() ),
            
            card(card_header(tags$h3("Converting time units")),
            converting_rate_card()),
            col_widths = c(6,6)
        ),
        about(),
        
        ),
       
        
      nav_panel("Scaling of recruitment rate", value = "scaling",
                tags$div(style = "height:20px"),
                
        #Remove arrows from numerical inputs
        
        tags$head(
          tags$style(HTML("
        input[type=number] {
              -moz-appearance:textfield;
        }
        input[type=number]::{
              -moz-appearance:textfield;
        }
        input[type=number]::-webkit-outer-spin-button,
        input[type=number]::-webkit-inner-spin-button {
              -webkit-appearance: none;
              margin: 0;
        }
        "))),
        
        # Suppresses error messages by colouring them to the bg colour
        tags$head(
          tags$style(".shiny-output-error{color: white;}")
        ),

         
        layout_columns(
          card(card_header(tags$h5("User input")), 
               height = 800,
               scaling_input() 
          ),
          layout_columns(

                 layout_columns(
                     card(card_header(tags$h5("Cumulative recruitment")),
                          height = 400,
                          plotOutput("sum_plot")
                     ),
                     card(card_header(tags$h5("Summary")),
                          height = 400,
                          tags$div(style = "height:5px"),
                          uiOutput("sum_text"),
                          hr(style = "margin-top:-8px ; margin-bottom : -10px; padding: 0"),
                          hr(style = "margin-top:-10px ; margin-bottom : -5px; padding: 0"),
                          p(tags$b("Quantiles"), style = "margin-bottom:-20px ; font-size:90%"),
                          tableOutput("sum_quant")
                      ) 
            ),
            card(card_header(tags$h5("Distributions")),
                 height = 400, 
                 card_body(
                   #plotOutput("both_plots"),
                   plotOutput("double_plot")
                   ) 
                 ),
            col_widths = c(12,12)  
          ),

          col_widths = c(4,8)
        ),
      ),
      
      nav_panel("Converting time unit", value = "converting",
        tags$div(style = "height:20px"), 
        layout_columns( 
          
          #First column with 2 cards
          layout_columns(
          card(card_header(tags$h5("User input")), #fill = F,
                    height = 500,
                    converting_input()), 

          col_widths = c(12)
          ),
             
          #second columns (twice as large)
          layout_columns(
            
            card(card_header(tags$h5("Cumulative recruitment")),
                 height = 400,
                 plotOutput("sum_plot_4_base") 
            ),
             
            card(card_header(tags$h5("Summary")),
                 height = 400, 
                 tags$div(style = "height:5px"),
                 uiOutput("sum_text_4"),
                 hr(style = "margin-top:-8px ; margin-bottom : -10px; padding: 0"),
                 hr(style = "margin-top:-10px ; margin-bottom : -5px; padding: 0"),
                 p(tags$b("Quantiles"), style = "margin-bottom:-20px ; font-size:90%"),
                 tableOutput("sum_quant_4")
            ),
            card(card_header(tags$h5("Distributions")),
                 height = 400,
                 plotOutput("distr_plot_pdf_ex4")),
            
            card(card_header(tags$h5("Cumulative distribution functions")),
                 height = 400, 
                 plotOutput("distr_plot_cdf_ex4") 
            ),
             
            
            col_widths = c(6, 6, 6, 6) 
          ),
           
           
          col_widths = c(4,8)
        ), 
      ),
    
    #   testing panel - left to simplify further development
    #
    #   nav_panel("testing panel", 
    #      p("hello world"),
    #      textOutput("buf") 
    #    )
    
    ) 
)


# Define server logic
server <- function(input, output) { 
  
   
  ### Defining global variables  
     
  init_non_reactives(input,output)          
        
  init_reactives(input, output)
   
  buffers(input, output)  
  
  
  
  ### Information module 
  
  about_output(input, output) 
  
  
  
  ### Scaling of recruitment module
  
  count_pmf_graph(input, output)          
    
  cdf_pdf_output(input, output)   
        
  summary_text(input, output)     
      
  summary_plot_output(input, output)  
     
  summary_text_choice(input, output) 
  
  summary_quantile_choice(input,output) 
          
  
    
  ### Converting time units module
  
  original_input(input, output)  
  
  distr_plot_ex_4(input,output)     
  
  table_choice(input, output) 
  
  pred_scaling_mode(input, output)
  
  summary_plot_output_4_base(input, output) 
  
  summary_text_choice_4(input, output) 
   
  summary_text_4(input, output) 
  
  summary_quantile_choice_4(input, output)
    
  conversion_text(input,output) 
            
         
  ### Helper functions module
        
  switch_tab_info_buttons(input,output)
         
  select_UI(input, output) 
  
  slider_ff_UI(input, output)     
     
  slider_UI(input, output)    
          
  input_text(input, output)   
                    
  screenshots(input,output)
              
              

}  
   
# Run the application 
shinyApp(ui = ui, server = server) 
