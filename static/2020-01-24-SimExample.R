# This is an example SimDesign script to conduct an analysis of
# Type I error and power rates for the independent groups t-test 
# under violations of homogeneity of variance.
library(SimDesign)
Design <- createDesign(sample_size = c(30, 60, 120),
                      group_size_ratio = c(1, 2),
                      sd_ratio = c(1/4, 1, 4),
                      mean_diff = c(0, 0.5))
head(Design)
#----------------------------------------------------------------

Generate <- function(condition, fixed_objects = NULL){
  # Attach() makes the variables in condition directly accesible
  Attach(condition)
  N1 <- sample_size / (group_size_ratio + 1)
  N2 <- sample_size - N1
  group1 <- rnorm(N1)
  group2 <- rnorm(N2, mean=mean_diff, 
                  sd=sd_ratio)
  dat <- data.frame(group = c(rep('g1', N1), rep('g2', N2)), 
                    DV = c(group1, group2))
  dat
}

Analyse <- function(condition, dat, fixed_objects = NULL){
  welch <- t.test(DV ~ group, dat)
  ind <- t.test(DV ~ group, dat, var.equal=TRUE)
  ret <- c(welch=welch$p.value, independent=ind$p.value)
  ret
}

Summarise <- function(condition, results, fixed_objects = NULL){
  ret <- EDR(results, alpha = .05)
  ret
}

#----------------------------------------------------------------
results <- runSimulation(design = Design, 
                         replications = 1000, 
                         parallel = TRUE,
                         generate = Generate, 
                         analyse = Analyse, 
                         summarise = Summarise)
head(results)
#----------------------------------------------------------------

# Communicate results!
TypeI <- subset(results, mean_diff == 0)
Power <- subset(results, mean_diff != 0)
print(TypeI, reps = FALSE, time = FALSE)

library(ggplot2)
ggplot(TypeI, 
       aes(factor(sd_ratio), welch)) + 
  geom_boxplot() + ylim(c(0,.2))
ggplot(TypeI, 
       aes(factor(sd_ratio), independent)) + 
  geom_boxplot() + ylim(c(0,.2)) 