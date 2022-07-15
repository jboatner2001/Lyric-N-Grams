# Extract words so they can be merged together

bigrams <- read.csv("kanye bigrams.csv")
trigrams <- read.csv("kanye trigrams.csv")
quadgrams <- read.csv("kanye quadgrams.csv")

# rename columns
names(bigrams)[1] <- "bigrams"
names(bigrams)[2] <- "frequency"

names(trigrams)[1] <- "trigrams"
names(trigrams)[2] <- "frequency"

names(quadgrams)[1] <- "quadgrams"
names(quadgrams)[2] <- "frequency"



# Clean out quotes and parenthesis

bigrams$bigrams <- gsub("\'", "", bigrams$bigrams)
bigrams$bigrams <- gsub("\\(", "", bigrams$bigrams)
bigrams$bigrams <- gsub("\\)", "", bigrams$bigrams)

trigrams$trigrams <- gsub("\'", "", trigrams$trigrams)
trigrams$trigrams <- gsub("\\(", "", trigrams$trigrams)
trigrams$trigrams <- gsub("\\)", "", trigrams$trigrams)

quadgrams$quadgrams <- gsub("\'", "", quadgrams$quadgrams)
quadgrams$quadgrams <- gsub("\\(", "", quadgrams$quadgrams)
quadgrams$quadgrams <- gsub("\\)", "", quadgrams$quadgrams)

# Pull out individual words

bigrams$first_word <- substr(bigrams$bigrams, 1, regexpr(",", bigrams$bigrams)-1)
bigrams$second_word <- gsub(".*,", "", bigrams$bigrams)

trigrams$first_word <- substr(trigrams$trigrams, 1, regexpr(",", trigrams$trigrams)-1)
trigrams$second_bigram <- sub("^.*?,", "", trigrams$trigrams)
trigrams$second_word <- substr(trigrams$second_bigram, 1, regexpr(",", trigrams$second_bigram)-1)
trigrams$third_word <- gsub(".*,", "", trigrams$trigrams)

# drop unneeded column
trigrams <- subset(trigrams, select = -c(4))

quadgrams$first_word <- substr(quadgrams$quadgrams, 1, regexpr(",", quadgrams$quadgrams)-1)
quadgrams$second_trigram <- sub("^.*?,", "", quadgrams$quadgrams)
quadgrams$second_word <- substr(quadgrams$second_trigram, 1, regexpr(",", quadgrams$second_trigram)-1)
quadgrams$second_bigram <- sub("^.*?,", "", quadgrams$second_trigram)
quadgrams$third_word <- substr(quadgrams$second_bigram, 1, regexpr(",", quadgrams$second_bigram)-1)
quadgrams$fourth_word <- gsub(".*,", "", quadgrams$second_bigram)

# drop unneeded column
quadgrams <- subset(quadgrams, select = -c(4,6))

# merge on concatenated words

bigrams$concat_two <- paste0(bigrams$first_word, bigrams$second_word)

trigrams$concat_two <- paste0(trigrams$first_word, trigrams$second_word)
trigrams$concat_three <- paste0(trigrams$first_word, trigrams$second_word, trigrams$third_word)

quadgrams$concat_two <- paste0(quadgrams$first_word, quadgrams$second_word)
quadgrams$concat_three <- paste0(quadgrams$first_word, quadgrams$second_word, quadgrams$third_word)

merge <- merge(bigrams, trigrams, by = "concat_two", all.x = FALSE, all.y = TRUE)

merge_2 <- merge(trigrams, quadgrams, by = "concat_three", all.x = FALSE, all.y = TRUE)

all_merge <- merge(merge, merge_2, by = "concat_three", all.x = FALSE, all.y = TRUE)

# clean up final data

final_merge <- all_merge[,c(5:6,3:4,11,7:8,23,18:19)]

# renames for clarity
names(final_merge)[1] <- "First.Word"
names(final_merge)[2] <- "Second.Word"
names(final_merge)[3] <- "Bigrams"
names(final_merge)[4] <- "Bigram.Count"
names(final_merge)[5] <- "Third.Word"
names(final_merge)[6] <- "Trigrams"
names(final_merge)[7] <- "Trigram.Count"
names(final_merge)[8] <- "Fourth.Word"
names(final_merge)[9] <- "Quadgrams"
names(final_merge)[10] <- "Quadgram.Count"

write.csv(final_merge, "kanye n-grams.csv")