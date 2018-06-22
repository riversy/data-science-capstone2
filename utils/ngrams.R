source('utils/requirements.R')

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

get_ngrams_table <- function(lines, n_words = 2) {
  get.phrasetable( 
    ngram(lines, n = n_words)
  )
}


