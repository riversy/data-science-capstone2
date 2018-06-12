require("loggit")
library("R6")

# Init CLass
Logger <- R6Class("Logger")

# Init Static Method 
# for Info message
Logger$info <- function(message) {
  loggit("INFO", message)
}

# Init Static Method 
# for Debug message
Logger$debug <- function(message) {
  loggit("DEBUG", message)
}