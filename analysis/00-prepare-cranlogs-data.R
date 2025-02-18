
start <- as.Date('2012-10-01')
today <- as.Date('2022-03-01')
all_days <- seq(start, today, by = 'day')
year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')
writeLines(urls, "pkg_cranlogs.txt")

# Use wget to obtain files with short random delay
# system("wget -i pkg_cranlogs.txt -w 2s -P cranlogs/")

# Process data into a smaller more suitable format for analysis
# Reduces 1 row per package download to become 1 row per package per day
# 
# Attempts to distinguish between duplicate downloads using metadata to give
# unique downloads, which is comparable to the total downloads typically
# reported.
library(tidyverse)
library(progressr)
paths <- list.files("cranlogs/", pattern = "\\.csv\\.gz$", full.names = TRUE)

# Remove already processed files
done_paths <- list.files("cranlogs/processed/", pattern = "\\.csv\\.gz$")
paths <- paths[!(basename(paths) %in% done_paths)]

process_data <- function(paths) {
  p <- progressor(along = paths)
  for(file in paths) {
    read_csv(file,
             col_types = cols(
               date = col_date(format = ""),
               time = col_time(format = ""),
               size = col_double(),
               r_version = col_character(),
               r_arch = col_character(),
               r_os = col_character(),
               package = col_character(),
               version = col_character(),
               country = col_character(),
               ip_id = col_double()
             )) %>% 
      count(date, r_version, r_arch, r_os, package, version, country, ip_id) %>% 
      group_by(date, package) %>% 
      summarise(n_unique = n(), n_total = sum(n), .groups = "drop") %>% 
      write_csv(file.path(dirname(file), "processed", basename(file)))
    gc()
    p(xfun::sans_ext(basename(file)))
  }
  invisible(NULL)
}

handlers("progress")
with_progress(process_data(paths))

# psql
# COPY cran_logs FROM PROGRAM 'tail --quiet -n +2 /cranlogs/*.csv' csv;
