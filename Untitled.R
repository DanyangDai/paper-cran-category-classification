

library(cranlogs)

cran_downloads("shinycustomloader",when = "last-week")
cran_downloads("glue",when = "last-week")
cran_downloads("shiny",when = "last-week")

start <- as.Date("2022-04-27")
end <- as.Date("2022-04-29")
all_days <- seq(start, end, by = 'day')


urls <- paste0('http://cran-logs.rstudio.com/', year, '/',all_days , '.csv.gz')

test <- read.csv("http://cran-logs.rstudio.com/2022/2022-04-27.csv.gz")

n <- 10000

for (i in 1:n){
  install.packages("nestr")
}
