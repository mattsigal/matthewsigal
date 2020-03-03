# RUN FIRST ON YOUR PERSONAL COMPUTER
install.packages("devtools", dependencies = TRUE)
install.packages(c("rmarkdown", "knitr"), dependencies = TRUE)
install.packages("tidyverse", dependencies = TRUE)
devtools::install_github("crsh/papaja", upgrade = "never") 
#devtools::install_github("benmarwick/wordcountaddin", type = "source", dependencies = TRUE)

install.packages("tinytex")
tinytex::install_tinytex()