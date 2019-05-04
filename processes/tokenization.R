source('utils/requirements.R')
source('utils/constants.R')
source('utils/logger.R')
source('utils/data_fetcher.R')
source('utils/ngrams.R')



clean_corpus_file_names <- get_file_name_in_data_set_folder('all_clean')
clean_head_lines <- read_lines(clean_corpus_file_names, n_max = 10)

n_grams_etalon <- get_ngrams_table(clean_head_lines, 1)
n_grams_compare <- get_empty_ngram_table()

for (index in 1:10) {
  
  n_grams_line <- get_ngrams_table(clean_head_lines[index], 1)

  n_grams_compare <- add_ngram_table(n_grams_compare, n_grams_line)
  
  

}

