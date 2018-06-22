source('utils/requirements.R')
source('utils/logger.R')
source('utils/constants.R')
source('utils/data_fetcher.R')
source('utils/data_pumping.R')
source('utils/text_clear.R')

require(Hmisc)

#
# This file cleanup all necessary data sets and put it into separated files.
#

ensure_data()

sys_time <- Sys.time()

all_clean_data_name = 'all_clean'

# 
# Remove all clean data set to
# fulfill it again.
# 
remove_data(all_clean_data_name)

#
# For every data set name procced split to 
# sentence operation and clean it. 
# Copy to common data set after cleaning. 
# 
for (source_name in data_set_names_to_extract) {
  
  splitted_to_sentences_data_set_name <- sprintf('%s_splitted', source_name) 
  clean_data_set_name <- sprintf('%s_clean', source_name) 
  
  data_pump_data(
    source_name,
    splitted_to_sentences_data_set_name,
    function(lines){
      split_to_sentences(lines)
    },
    label = sprintf('Split %s to sentences.', capitalize(source_name))
  )
  
  data_pump_data(
    splitted_to_sentences_data_set_name,
    clean_data_set_name,
    function(lines){
      clean_text_data(lines)
    },
    label = sprintf('Cleaning %s corpus.', capitalize(source_name))
  )
  
  copy_data(
    clean_data_set_name,
    all_clean_data_name,
    label = sprintf('Copy %s to corpus with all cleaned data.', capitalize(source_name))
  )
}

Logger$info("OK")

elapsed_time <- Sys.time() - sys_time
Logger$debug(sprintf("Overall cleaning took %s seconds.", elapsed_time))
