source('utils/requirements.R')
source('utils/constants.R')
source('utils/data_fetcher.R')

require(readr)

#
# Read text files by chunks, 
# process with callback function and 
# write into text file.
# 
# Example:
#
# data_pump_data(
#   'twitter',
#   'twitter_sentence',
#   function(lines){
#     split_to_sentences(lines)
#   },
#   label = 'Split Twitter to Sentences.'
# )
#
data_pump_data <- function(name_from, name_to, callback, label = '', keep_file = TRUE) {
  
  sys_time <- Sys.time()
  
  if (label != ''){
    Logger$info(label) 
  }
  
  Logger$info(
    sprintf("Processing data from '%s' to '%s'...", name_from, name_to)
  )
  
  read_from_file_name <- get_file_name_in_data_set_folder(name_from)
  write_to_file_name <- get_file_name_in_data_set_folder(name_to)
  
  if (file.exists(write_to_file_name)){
    
    if (keep_file){
      
      Logger$info(
        sprintf("File %s exists. Keep file.", write_to_file_name)
      )
      
      return() 
      
    } else {
      
      Logger$info(
        sprintf("File %s exists. Removing.", write_to_file_name)
      )
      
      file.remove(write_to_file_name)
    }
  }
  
  read_lines_chunked(read_from_file_name, callback = function(lines, pos){
    
    lines <- callback(lines)
    
    write_lines(lines, write_to_file_name, append = TRUE)
  }) 
  
  Logger$info("OK")
  
  elapsed_time <- Sys.time() - sys_time
  Logger$debug(sprintf("Processing step took %s seconds.", elapsed_time))
}

#
# Remove some picked Data Set. 
# 
# Example:
# 
# remove_data('name')
#
remove_data <- function(name) {
  remove_file_name <- get_file_name_in_data_set_folder(name)
  
  if (file.exists(remove_file_name)) {
  
    Logger$info(
      sprintf("File %s exists. Removing.", remove_file_name)
    )
    
    file.remove(remove_file_name)  
  } else {
    Logger$info(
      sprintf("File %s doesn not exists.", remove_file_name)
    )
  }
  
  Logger$info('OK');

}

#
# Copy data from one Data Set to Another.
# 
# Example:
# 
# copy_data(
#   clean_data_set_name,
#   all_clean_data_name,
#   label = sprintf('Copy %s to corpus with all cleaned data.', capitalize(source_name))
# )
#
copy_data <- function(name_from, name_to, label = ''){

  sys_time <- Sys.time()
    
  if (label != ''){
    Logger$info(label) 
  }

  Logger$info(
    sprintf("Copy data from '%s' to '%s'...", name_from, name_to)
  )
  
  read_from_file_name <- get_file_name_in_data_set_folder(name_from)
  write_to_file_name <- get_file_name_in_data_set_folder(name_to)
  
  read_lines_chunked(read_from_file_name, callback = function(lines, pos){
    write_lines(lines, write_to_file_name, append = TRUE)
  }) 

  elapsed_time <- Sys.time() - sys_time
  
  Logger$debug(sprintf("Processing step took %s seconds.", elapsed_time))
}



