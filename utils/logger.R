require("loggit")
library("R6")

# Init CLass
Logger <- R6Class("Logger")

Logger$silent <- FALSE

# Init Static Method 
# for Info message
Logger$info <- function(message) {
  if (!Logger$silent) {
    loggit("INFO", message)  
  }
}

# Init Static Method 
# for Debug message
Logger$debug <- function(message) {
  if (!Logger$silent) {
    loggit("DEBUG", message)
  }
}