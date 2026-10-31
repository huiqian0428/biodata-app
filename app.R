library(shiny)

# Pre-defined choices
sports_list <- c("Football", "Basketball", "Tennis", "Pickleball", "Dancing", "Swimming")
drink_list  <- c("Coffee", "Tea", "Matcha", "Fruit Juice", "Water")
hobby_list <- c("Reading", "Gaming", "Traveling", "Cooking", "Music")

ui <- fluidPage(
  titlePanel("Friends Biodata Collection"),
  
  # Section 1: Simple Inputs
  h3("Enter Your Information"),
  
  textInput("name", "Write your full name:"),
  dateInput("dob", "When is your birth date?", value = "2000-01-01"),
  radioButtons("sport", "What is your favorite sport activity?", choices = sports_list),
  selectInput("drink", "What is your favorite beverage?", choices = drink_list),
  checkboxGroupInput("hobbies", "Select your hobbies:", choices = hobby_list ),
  sliderInput("marriage_age", "At what age range do you think you will marry?", 
              min = 18, max = 80, value = c(25, 32)),
  checkboxInput("subscribe", "I agree to share this biodata with friends.", value = TRUE),
  
  hr(),
  
  # Section 2: Simple Outputs
  h3("Collected Information"),
  
  # Output 1: Text
  textOutput("greeting_text"),
  br(),
  
  # Output 2: Table
  h4("Biodata Summary Table"),
  tableOutput("biodata_table")
)

server <- function(input, output, session) {
  
  # 1. Text Output
  output$greeting_text <- renderText({
    if (input$name == "") {
      "Hello! Please type your full name above."
    } else {
      paste0("Hi ", input$name, "! Nice to meet you!")
    }
  })
  
  # 2. Table Output
  output$biodata_table <- renderTable({
    data.frame(
      Field = c("Full Name", "Date of Birth", "Favorite Sport", "Favorite Beverage", "Hobbies", "Expected Marriage Age Range", "Consent Agreed"),
      Value = c(
        ifelse(input$name == "", "Not provided", input$name),
        as.character(input$dob),
        input$sport,
        input$drink,
        ifelse(length(input$hobbies) == 0, "None selected", paste(input$hobbies, collapse = ", ")),
        paste(input$marriage_age[1], "to", input$marriage_age[2], "years old"),
        ifelse(input$subscribe, "Yes", "No")
      ),
      stringsAsFactors = FALSE
    )
  })
}

shinyApp(ui, server)
