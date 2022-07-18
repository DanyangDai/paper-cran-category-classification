# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("tidyverse", "lubridate", "cranlogs", "DBI", "rvest", "pkgsearch","purrr","broom"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
#options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Load the R scripts with your custom functions:
lapply(list.files("R", full.names = TRUE, recursive = TRUE), source)
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  # input data 
  tar_target(daily_download_collect, collect_data()),
  tar_target(daily_download, daily_download_data(daily_download_collect)),
  
  
  # package updates and releases
  # tar_target(pkg_names, pull(cranscrub::pkg_db(), Package)),
  # tar_target(pkg_releases1, get_pkg_releases(pkg_names[1:3000])),
  # tar_target(pkg_releases2, get_pkg_releases(pkg_names[3001:6000])),
  # tar_target(pkg_releases3, get_pkg_releases(pkg_names[6001:9000])),
  # tar_target(pkg_releases4, get_pkg_releases(pkg_names[9001:12000])),
  # tar_target(pkg_releases5, get_pkg_releases(pkg_names[12001:15000])),
  # tar_target(pkg_releases6, get_pkg_releases(pkg_names[15001:length(pkg_names)])),
  # tar_target(pkg_releases, bind_rows(pkg_releases1, pkg_releases2, pkg_releases3,
  #                                    pkg_releases4, pkg_releases5, pkg_releases6)),
  tar_target(pkg_releases, readRDS("data/target/pkg_releases.rds")), 
  
  # getting total annual data 
  tar_target(total_dfs, annual_download(2013:2021)),
  
  # IDA -- checks
  
  tar_target(plot_daily_download, plot_date_vs_counts(daily_download)),
  
  # Robust linear regression analysis of total vs unique counts
  
  tar_target(rlm_models, rlm_total_vs_unique_coeff(total_dfs)),
  tar_target(rlm_models_res_2013, rlm_year_residuals(total_dfs,2013)),
  tar_target(rlm_models_res_2014, rlm_year_residuals(total_dfs,2014)),
  tar_target(rlm_models_res_2015, rlm_year_residuals(total_dfs,2015)),
  tar_target(rlm_models_res_2016, rlm_year_residuals(total_dfs,2016)),
  tar_target(rlm_models_res_2017, rlm_year_residuals(total_dfs,2017)),
  tar_target(rlm_models_res_2018, rlm_year_residuals(total_dfs,2018)),
  tar_target(rlm_models_res_2019, rlm_year_residuals(total_dfs,2019)),
  tar_target(rlm_models_res_2020, rlm_year_residuals(total_dfs,2020)),
  tar_target(rlm_models_res_2021, rlm_year_residuals(total_dfs,2021)),
  tar_target(rlm_models_res, rbind(rlm_models_res_2013,rlm_models_res_2014,rlm_models_res_2015,
                                   rlm_models_res_2016,rlm_models_res_2017,rlm_models_res_2018,
                                   rlm_models_res_2019,rlm_models_res_2020,rlm_models_res_2021)),
  tar_target(rlm_coeffs_data, rlm_models %>% select(-data)),
  tar_target(rlm_coeffs_data_long, rlm_coeffs_data %>% 
               select(year, term, estimate) %>% 
               pivot_wider(id_cols = year, names_from =  term, values_from = estimate) %>%
               rename(intercept = `(Intercept)`,
                      coeff = `annual_unique`)),
  tar_target(lm_large_resid, large_resid(rlm_models_res,10000,-1000)),
  
  # LM plots 
  
  tar_target(resid_plot_fitted_resid, resid_plots(rlm_models_res,'auginfo$.fitted','auginfo$.resid',year)),
  tar_target(intercept_plot_year, rlm_coeffs_data_long %>% 
               ggplot(aes(x = year, 
                          y = intercept, 
                          colour = coeff, 
                          label = year)) +
               geom_point()),
  tar_target(coeff_plot_year, rlm_coeffs_data_long %>% 
               ggplot(aes(x = year, 
                          y = coeff, 
                          colour = intercept, 
                          label = year)) +
               geom_point() +
               geom_line(group = 1)),
  # tar_target(lm_large_resid_plot, lm_large_resid %>% 
  #              mutate(value = ifelse(.resid >0, "Positive", "Negative")) %>% 
  #              ggplot(aes(x = year, fill = value)) +
  #              geom_bar(stat = "count")),
  #tar_target(lm_distance_plot,plot_lm_distance(total_dfs,lm_residuals_data)),
  
  # large rank diff 
  
  tar_target(large_rank_diff_data, large_rank_diff(total_dfs, 0,50)),
  tar_target(large_rank_diff_top_pkgs, plot_large_rank_diff(total_dfs,large_rank_diff_data)),
  
  NULL
)
