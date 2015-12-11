main <- c("CLW-R-Learning")
n1 <- length(main)

name <- c("Jason", "Sanly", "Oracle")
n2 <- length(name)

share <- c("Statistics", "NCCU")
n3 <- length(share)

language <- c("R", "Python", "SQL")
n4 <- length(language)

package <- c("ggplot2", "dplyr", "ggmap", "reshape2",
             "Numpy", "Matplotlib", "Scipy")
n5 <- length(package)

methods <- c("Administration", "Bootstrap",
            "Clustering Analysis", "Cross Validation",
            "Linear Discriminant Analysis",
            "Logistic Regression",
            "Principal Component Analysis", "Regression",
            "Singular Value Decomposition",
            "Support Vector Machine",
            "Tree")
n6 <- length(methods)

words <- c(main, name, share, language, package, methods)
freq <- c(235, 130, 130, 130, 185, 60, 170, 100, 70,
          rep(30, n5), rep(10, n6))

library(wordcloud)
library(RColorBrewer)

png(file="CLW-logo.png", bg="transparent")
set.seed(0)
pal <- brewer.pal(8, "Dark2")
wordcloud(words, freq, rot.per=0.1, colors=pal)
dev.off()
