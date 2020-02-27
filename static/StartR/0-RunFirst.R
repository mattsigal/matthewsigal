# RUN FIRST
install.packages("devtools")
install.packages(c("rmarkdown", "knitr"))
install.packages("tidyverse")
devtools::install_github("crsh/papaja", upgrade = "never") 
devtools::install_github("benmarwick/wordcountaddin", type = "source", dependencies = TRUE)

install.packages("tinytex")
tinytex::install_tinytex()