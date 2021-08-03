library(httr)
library(jsonlite)
base_url  <- "http://cranlogs.r-pkg.org/"
daily_url <- paste0(base_url, "downloads/daily/")
top_url   <- paste0(base_url, "top/")

# Getting all the total R packages download numbers from 2012
library(cranlogs)
dd_start <- "2012-10-01"
dd_end <- Sys.Date() - 1

is_weekend <- function(date) {
  weekdays(date) %in% c("Saturday", "Sunday")
}

total_downloads <- cran_downloads(from = dd_start, to = dd_end) %>%
  mutate(year = year(date),
         day = yday(date),
         weekend = is_weekend(date)) %>%
  filter(row_number() <= n() - 1)

save(total_downloads, file = "data/derived/total_downloads.Rdata")


# Getting the top 100 most popular downloads from http://cranlogs.r-pkg.org/top/
get_downloads <-
  function (when = c("last-day", "last-week", "last-month"),
            count = 100)
  {
    when <- match.arg(when)
    req <- GET(paste0(top_url, when, "/", count))
    stop_for_status(req)
    r <- fromJSON(content(req, as = "text", encoding = "UTF-8"),
                  simplifyVector = FALSE)
    df <- data.frame(
      stringsAsFactors = FALSE,
      package = vapply(r$downloads, "[[", "", "package"),
      count = as.integer(vapply(r$downloads,
                                "[[", "", "downloads")),
      from = as.Date(r$start),
      to = as.Date(r$end)
    )
    if (nrow(df) != count) {
      warning("Requested ", count, " packages, returned only ",
              nrow(df))
    }
    df
  }

download_top100 <- get_downloads(when="last-month")
save(download_top100, file = "data/derived/download_top100.Rdata")


library(installr)
# Download the cranlog on 2014-11-17, the first R packages spike
spilk_2014_dir <-
  download_RStudio_CRAN_data(START = '2014-11-17',
                             END = '2014-11-17',
                             log_folder = "/Users/daidanyang/Documents/GitHub/paper-cran-category-classification/paper/Data/derived")
# read .gz compressed files form local directory
spilk_2014 <-
  read.csv(
    "~/Documents/GitHub/paper-cran-category-classification/paper/Data/2014-11-17.csv.gz"
  )
#save the data locally
save(spilk_2014, file = "Data/derived/spilk_2014.RData")




# download the cranlog on 2018-10-21 
spilk_2018_dir <- download_RStudio_CRAN_data(START = '2018-10-21',END = '2018-10-21', log_folder="/Users/daidanyang/Documents/GitHub/paper-cran-category-classification/paper/Data/derived")

# read .gz compressed files form local directory
spilk_2018 <- read_RStudio_CRAN_data(spilk_2018_dir)

#save the data locally 
save(spilk_2018, file = "Data/derived/spilk_2018.RData")







