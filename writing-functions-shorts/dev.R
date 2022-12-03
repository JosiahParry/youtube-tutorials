# functions do things
# like print out messages
print("hello world")

# or... create random numbers
rbinom(100, 1, 0.2)

# they make complex code easy to repeat
# most functions start out as a few lines of code

# count the number of words, the average number of letters
# the fewest number of letters, and the most

# when writing functions, think small. make a function
# work on only one thing at a time. then apply that function 
# to a lot of things using iteration 
library(stringr)

# generate some random data
paragraph <- stringi::stri_rand_lipsum(1, TRUE)

# remove all punctuation
no_punct <- str_replace_all(paragraph, "[:punct:]", " ")

# split on on words
words <- str_split(no_punct, boundary("word"))

# count number of characters per word
word_chars <- nchar(words[[1]])

# summarize the sentence
data.frame(
  n_words = length(word_chars),
  avg_chars = mean(word_chars),
  shortest = min(word_chars),
  longest = max(word_chars)
)

# make a function
#| functions are objects created with a special keyword `function`
#| the _body_ of the function is executed
#| whatever is printed last is returned
summarise_sentence <- function() {
  
}

summarise_sentence()


#| nothing is ran so nothing is returned

summarise_sentence <- function() {
  "hello world"
}

summarise_sentence()

#| functions take inputs called arguments
#| arguments act like objects that are only available in the 
#| function body
summarise_sentence <- function(sentence) {
  sentence 
}

summarise_sentence("hi how are you")


# use the argument name in the body of the function

summarise_sentence <- function(sentence) {
  
  no_punct <- str_remove_all(sentence, "[:punct:]")
  
  no_punct
}

# fill in the rest

summarise_sentence <- function(sentence) {
  
  no_punct <- str_replace_all(sentence, "[:punct:]", " ")
  words <- str_split(no_punct, boundary("word"))
  word_chars <- nchar(words[[1]])
  
  # what is printed last is returned
  data.frame(
    n_words = length(word_chars),
    avg_chars = mean(word_chars),
    shortest = min(word_chars),
    longest = max(word_chars)
  )
}


summarise_sentence(paragraph)




# using your functions ----------------------------------------------------

#> if you haven't watched hte last video, go od that
#> Read in the communist manifest from project gutenberg
manifesto <- gutenbergr::gutenberg_download(61)

#> extract the text and paste it together into one long string
text_raw <- paste0(manifesto[["text"]], collapse = " ")

# next, split the string so each sentence is its own element
all_sentences <- str_split(full_text, "\\.")[[1]]

library(tidyverse)

# create a dataframe 
df <- tibble(
  id = seq_along(all_sentences), 
  sentence = all_sentences
)

df


df |> 
  mutate(sentence_summary = summarise_sentence(sentence)) |> 
  glimpse()


manifesto_summary <- df |> 
  mutate(
    sentence_summary = purrr::map(sentence, summarise_sentence)
  ) |> 
  unnest_wider(sentence_summary) 


ggplot(manifesto_summary, aes(n_words)) +
  geom_histogram()


manifesto_summary |> 
  slice_max(n_words, n = 1) |> 
  pull(sentence) |> 
  str_split(boundary("sentence"))
  

