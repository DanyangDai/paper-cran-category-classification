# Getting all the updates data and store them locally 
library(pkgsearch)
updates <-map_dfr(cran_names[1:1000], cran_package_history)
updates_2 <- map_dfr(cran_names[1001:3000], cran_package_history)
updates_3 <- map_dfr(cran_names[3001:4000], possibly(cran_package_history, NULL))
updates_4 <- map_dfr(cran_names[4001:6000], possibly(cran_package_history, NULL))
updates_5 <- map_dfr(cran_names[6001:8000], possibly(cran_package_history, NULL))
updates_6 <- map_dfr(cran_names[8001:10000], possibly(cran_package_history, NULL))
updates_7 <- map_dfr(cran_names[10001:12000], possibly(cran_package_history, NULL))
updates_8 <- map_dfr(cran_names[12001:14000], possibly(cran_package_history, NULL))
updates_9 <- map_dfr(cran_names[14000:17828], possibly(cran_package_history, NULL))


save(updates, file = "updates.Rdata")
save(updates_2, file = "updates_2.Rdata")
save(updates_3, file = "updates_3.Rdata")
save(updates_4, file = "updates_4.Rdata")
save(updates_5, file = "updates_5.Rdata")
save(updates_6, file = "updates_6.Rdata")
save(updates_7, file = "updates_7.Rdata")
save(updates_8, file = "updates_8.Rdata")
save(updates_9, file = "updates_9.Rdata")

library(purrr)
library(dplyr)

# Select package name, version and date from all the updates datasets
select_pkg_ver_date <- function(x) { 
  x %>%       
    dplyr::select(Package,Version,date)
}






