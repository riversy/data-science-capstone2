source("utils/requirements.R")
source("utils/constants.R")
source("utils/logger.R")

#
# Generates a filename in Zipped Source file 
#
get_file_name_in_source_zip <- function(data_set_name, locale_name = "en_US") {
  sprintf("final/%s/%s.%s.txt", locale_name, locale_name, data_set_name)
}

#
# Generates a filename in DataSet folder
#
get_file_name_in_data_set_folder <- function(data_set_name, locale_name = "en_US") {
  sprintf("data_set/%s.%s.txt", locale_name, data_set_name)
}

#
# Ensure all necesary DataSet files exists unpacked and ready for work
#
ensure_data_set_files <- function() {
  Logger$info("Probing files in ZIP...")
  
  for (locale_name in locales_to_extract) {
    for (data_set_name in data_set_names_to_extract) {
      
      data_set_file_name = get_file_name_in_data_set_folder( data_set_name, locale_name )
      data_set_packed_file_name = get_file_name_in_source_zip( data_set_name, locale_name )
      
      Logger$info(sprintf("Probing file %s.", data_set_file_name))     
      
      if (!file.exists(data_set_file_name)) {
        Logger$info(sprintf("  - %s not exists. Unzip it from source.", data_set_file_name))
        
        unzip(
          zipfile = source_file_name, 
          files = data_set_packed_file_name, 
          exdir = data_set_folder_name, 
          junkpaths = TRUE
        )
      } else {
        Logger$info("OK")
      }
    }
  }
}

#
# Fetch Source File from Internet
# 
fetch_source_from_internet <- function() {
  
  Logger$info("Fetching sources from internet...")
  download.file(source_url, source_file_name, cacheOK = TRUE)
}

#
# Ensure all DataSet files unzipped and ready for work
#
ensure_data <- function() {
  Logger$info("Ensure Source Data")
  
  if (!file.exists(source_file_name)) {
    
    Logger$info("Source file doesn't exists.")
    fetch_source_from_internet()
  } 
  
  Logger$info("Source file is here. Ensure data set files.")
  ensure_data_set_files()
}

#
# Retrieves data by DataSet name. All data combined into one dictionary. 
# If parameter 'name' is empty it will load all known DataSets.
#
get_raw_data <- function(data_set_name = "") {
  sys_time <- Sys.time()
  
  Logger$info("Loading Raw Data")
  
  if (data_set_name != "") {
    
    Logger$info( sprintf("Loading '%s' Data Set...", data_set_name) )
    names <- c(data_set_name)
  } else {
    
    Logger$info("Loading Everything...")
    names <- data_set_names_to_extract
  }
  
  lines <- c()
  for (name in names) {
    
    file_path <- get_file_name_in_data_set_folder(name)
    connection <- file(file_path)
    data.lines <- readLines(connection, encoding = 'UTF-8', skipNul = TRUE)
    close(connection)
    lines <- c(lines, data.lines)
  }
  
  Logger$info("OK")
  
  elapsed_time <- Sys.time() - sys_time
  Logger$debug(sprintf("Operation took %s seconds.", elapsed_time))
  
  lines
}


ensure_data()
news_raw_lines <- get_raw_data('news')
blogs_raw_lines <- get_raw_data('blogs')
twitter_raw_lines <- get_raw_data('twitter')
