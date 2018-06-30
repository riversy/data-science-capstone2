source('utils/requirements.R')
source('utils/constants.R')
source('utils/logger.R')
source('utils/data_fetcher.R')
source('utils/ngrams.R')

for (n_gram_index in 1:max_n_grams) {
  
  sys_time <- Sys.time()
  
  Logger$info(
    sprintf("Looking for N-Grams with N = '%s'", n_gram_index)
  )
  
  lines <- get_raw_data('all_clean')
  lines <- skip_lines_by_word_count(lines, n_words = n_gram_index)
  n_grams_table <- get_ngrams_table(lines, n_words = n_gram_index)
  rm(lines)
  
  n_grams_table_name <- sprintf('%s_grams', n_gram_index)
  
  n_grams_file_name <- get_file_name_in_data_table_folder(
    sprintf('%s_grams', n_gram_index)
  )
  
  saveRDS(n_grams_table, n_grams_table_name)
  
  rm(list = c('n_grams_table'))
  
  elapsed_time <- Sys.time() - sys_time
  Logger$debug(sprintf("Operation took %s seconds.", elapsed_time))
}

