source('utils/requirements.R')

require(ngram)
require(dplyr, quietly = TRUE)

#
# Filter text vector for lines 
# with more and equal words 
# then n_words.
#
skip_lines_by_word_count <- function(lines, n_words = 2) {
  
  if (n_words > 1){
    n_selector <- sprintf('{%s}', n_words - 1)  
  } else {
    n_selector <- '?'
  }
  
  n_select_pattern <- sprintf('[a-z_]+(\\s[a-z_]+)%s', n_selector)
  
  lines[grepl(n_select_pattern, lines)]
}

#
# Calculate N-Grams and return phrase table
#
get_ngrams_table <- function(lines, n_words = 2) {
  get.phrasetable( 
    ngram(lines, n = n_words)
  )
}

#
# Generate empty data table, identical 
# to ngram get.phrasetable generates.
#
get_empty_ngram_table <- function() {
  structure(
    list(
      ngrams = as.vector(character()), 
      freq = character(), 
      prop = character()
    ), 
    class = "data.frame"
  )
}


add_ngram_table <- function(ngram_table, ngram_table_to_add) {
  
  Logger$debug("add table")
  print(ngram_table_to_add)
  
  size <- nrow(ngram_table_to_add)
  
  for (index in 1:size) {
  
    ngram_value <- ngram_table_to_add$ngrams[index]
    ngram_pattern <- sprintf('^%s$', ngram_value)
    
    ngram_freq <- ngram_table_to_add$freq[index]
    ngram_prop <- ngram_table_to_add$prop[index]
      
    print(ngram_value)
    
    # 1. find line with ngram
    found_index <- which(regexpr(ngram_pattern, n_grams_compare$ngrams) == 1)
    
    if ( length(found_index) ) {
      
      # 2a. extract values
      # 3a. calculate and set
      ngram_table$freq[found_index] = ngram_table$freq[found_index] + ngram_freq
      ngram_table$prop[found_index] = ngram_table$prop[found_index] * ngram_prop / ngram_freq
    } else {
    
      # 2b. Add ngram into table of ngrams
      ngram_table <- rbind(ngram_table, ngram_table_to_add[index, ])
    }
  }
  
  size <- nrow(ngram_table)
  
  for (index in 1:size) {
    
  }
  
  
  
  Logger$debug("fulfilled table")
  print(ngram_table)
  
  ngram_table
}


