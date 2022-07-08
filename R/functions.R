

collect_data <- function() {
  con <- dbConnect(
    RPostgres::Postgres(),
    host = "db.mitchelloharawild.com",
    dbname = "cranlogs",
    user = "guest",
    password = "JNoGzAc9V5yxdsU9"
  )
  
  DBI::dbListTables(con)
  #> [1] "cran_logs"
  cran_logs <- tbl(con, "cran_logs")
  
  cran_logs %>% 
    group_by(file_date) %>% 
    summarise(download = sum(n_total),
              unique = sum(n_unique)) %>% 
    collect()
}

daily_download_data <- function(daily_download_collect) {
  daily_download_collect %>% 
    mutate(difference = download - unique) %>% 
    mutate(download = as.integer(download)) %>% 
    mutate(unique = as.integer(unique))
}


get_pkg_releases <- function(pkg_names) {
  map_dfr(pkg_names, possibly(cran_package_history, NULL)) %>% 
    group_by(Package) %>% 
    summarise(nupdate = n(),
              first_releasee = min(ymd_hms(date))) %>% 
    rename(package = Package)
}

saving_data <- function(data){
  saveRDS(data,file = paste0("../data/analysis/",data,".rds"))
}

db_connection <- function(){  
  con <- dbConnect(
  RPostgres::Postgres(),
  host = "db.mitchelloharawild.com",
  dbname = "cranlogs",
  user = "guest",
  password = "JNoGzAc9V5yxdsU9"
)
  DBI::dbListTables(con)
  #> [1] "cran_logs"
  cran_logs <- tbl(con, "cran_logs")
}

annual_download <- function(years){
  totals_df <- map_dfr(years,
                       ~{
                         readRDS(glue::glue("data/analysis/total_{.x}_pkg.rds")) %>% 
                           arrange(desc(annual_total)) %>% 
                           mutate(rank_total = 1:n(),
                                  age = year(Sys.Date()) - year(first),
                                  year = .x) 
                       })
}

rlm_total_vs_unique_coeff <- function(total_dfs){
  linear_model <- total_dfs %>% 
    group_by(year) %>% 
    nest() %>% 
    mutate(model = map(data, ~MASS::rlm(annual_total ~ annual_unique, data = .x)),
           coeff = map(model, ~tidy(.x))) %>% 
    select(-model) %>% 
    unnest(coeff)
  return(linear_model)
}

linear_models_residuals <- function(total_dfs){
  linear_model <- total_dfs %>% 
    group_by(year) %>% 
    nest() %>% 
    mutate(model = map(data, ~MASS::rlm(annual_total ~ annual_unique, data = .x)),
           auginfo = map2(model, data, ~ {
             augment(.x) %>% 
                mutate(package = data$package) 
             })) %>%     
    select(-model) %>% 
    unnest(auginfo) 
  return(linear_model)
}


unnest_lm <- function(variables, models){
  data <- models %>% 
    select(variables) %>% 
    unnest()
  return(data)
}

large_resid <- function(redis_data, positive, negative){
  redis_data %>% 
    filter(.resid >= positive | .resid <= negative) 
}

large_rank_diff <- function(total_dfs,benchmark_rank, top_rank){
     total_dfs %>% 
    filter(rank_diff > benchmark_rank) %>% 
    filter(rank_total < top_rank) %>% 
    group_by(package) %>% 
    summarise(rank_diff = sum(abs(rank_diff)),
              n = n()) %>% 
    filter(n > 3) %>% 
    arrange(desc(rank_diff)) %>% 
    slice(1:40) %>% 
    pull(package) 

}