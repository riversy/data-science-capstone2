source('utils/requirements.R')

#
# Split vector with line into sentences 
#
split_to_sentences <- function(text_corpus) {
  
  # 1. Split by punctuation
  text_corpus_sentences <- unlist(
    strsplit(
      text_corpus, 
      "(?<=[[:punct:]])\\s(?=[A-Z])", 
      perl=T
    )
  )
  
  # 2. Remove empty sentences
  text_corpus_sentences <- text_corpus_sentences[which(text_corpus_sentences != '')]
  
  text_corpus_sentences
}

#
# Clear data and prepare it for tockenization
#
clean_text_data <- function(text_corpus, profanity_words = c()) {
  
  # 1. Text to lower
  text_corpus_lower <- tolower(text_corpus)
  
  # 2. Extract words only
  text_corpus_words <- strsplit(text_corpus_lower, "\\W")

  # 3. Deal with cases like 'you' 'll' (you will) 
  #    Simply say, mapping for idioms
  text_corpus_words <- lapply(text_corpus_words, function(item){
    
    item <- replace(item, item=='ll', 'will')
    item <- replace(item, item=='m', 'am')
    item <- replace(item, item=='r', 'are')
    item <- replace(item, item=='re', 'are')
    item <- replace(item, item=='ve', 'have')
    item <- replace(item, item=='u', 'you')
    item <- replace(item, item=='im', 'i am')
    item <- replace(item, item=='its', 'it is')
    item <- replace(item, item=='thats', 'that is')
    
    item
  })
  
  # 4. Remove profanity words
  if (length(profanity_words) > 0){
    
    # Compile profanity words into one pattern
    profanity_words_regex_pattern = 
      sprintf(
        '^(%s)$', 
        paste(profanity_words, collapse = "|")
      )
    
    # Clean profanity words using Regexp pattern
    text_corpus_words <- lapply(text_corpus_words, function(item){
      item <- gsub(profanity_words_regex_pattern, '', item, perl = T)
      item
    })
  }
  
  # 5. Remove empty spaces
  text_corpus_words <- lapply(text_corpus_words, function(item){
    item <- item[which(item != '')]
    item
  })
  
  # 6. Concat it back to corpus again
  text_corpus_words <- lapply(text_corpus_words, function(item){
    item <- paste(item, collapse = ' ')
    
    # Change other popular shortcuts on sentence start 
    item <- gsub('(^|\\s)don t', '\\1do not', item)
    item <- gsub('(^|\\s)won t', '\\1will not', item)
    item <- gsub('(^|\\s)wouldn t', '\\1would not', item)
    item <- gsub('(^|\\s)shouldn t', '\\1should not', item)
    item <- gsub('(^|\\s)it s', '\\1it is', item)
    item <- gsub('(^|\\s)isn t', '\\1is not', item)
    item <- gsub('(^|\\s)i m', '\\1i am not', item)
    item <- gsub('(^|\\s)i d', '\\1i would', item)
    item <- gsub('(^|\\s)can t', '\\1can not', item)
    item <- gsub('(^|\\s)ain t', '\\1am not', item)
    
    item
  })
  
  text_corpus_clean <- unlist(text_corpus_words)
  
  # 7. Remove empty sentences
  text_corpus_clean <- text_corpus_clean[which(text_corpus_clean != '')]
  
  text_corpus_clean
}
