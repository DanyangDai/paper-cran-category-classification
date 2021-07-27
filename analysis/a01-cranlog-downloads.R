library(httr)
library(jsonlite)
base_url  <- "http://cranlogs.r-pkg.org/"
daily_url <- paste0(base_url, "downloads/daily/")
top_url   <- paste0(base_url, "top/")

get_downloads <- function (when = c("last-day", "last-week", "last-month"), count = 100) 
{
  when <- match.arg(when)
  req <- GET(paste0(top_url, when, "/", count))
  stop_for_status(req)
  r <- fromJSON(content(req, as = "text", encoding = "UTF-8"), 
                simplifyVector = FALSE)
  df <- data.frame(stringsAsFactors = FALSE, 
                   package = vapply(r$downloads, "[[", "", "package"), count = as.integer(vapply(r$downloads, 
                                                                                                 "[[", "", "downloads")), from = as.Date(r$start), 
                   to = as.Date(r$end))
  if (nrow(df) != count) {
    warning("Requested ", count, " packages, returned only ", 
            nrow(df))
  }
  df
}
