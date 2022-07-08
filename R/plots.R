
plot_date_vs_counts <- function(daily_download) {
  daily_download %>% 
    ggplot(aes(x = file_date)) +
    geom_line(aes(y = download), color = "red") + 
    geom_line(aes(y = unique), color = "blue") + 
    geom_line(aes(y = difference), color = "green")  
}

resid_plots <- function(resid_data, x, y, wrap){
  resid_data %>% 
    ggplot(aes(x = x,
               y = y)) +
    geom_point() +
    geom_hline(yintercept = 0, colour = "red") + 
    facet_wrap(~wrap, scales = "free")
}

plot_lm_distance<- function(total_dfs,lm_residuals_data){
  ggplot(data = total_dfs, 
         aes(x = annual_unique, y = annual_total)) +
    geom_point(alpha = 0.2) +
    geom_smooth(method="lm", se = FALSE) +
    # overlay fitted values
    geom_point(data = lm_residuals_data, 
               aes(y = .fitted), 
               color = "blue", 
               alpha = 0.2) +
    # draw a line segment from the fitted value to observed value
    geom_segment(data = lm_residuals_data, 
                 aes(y = .fitted, xend = annual_unique, yend = annual_total),
                 color = "blue",
                 alpha = 0.2) + 
    facet_wrap(~year)
}

plot_large_rank_diff <- function(total_dfs, rank_diff_pkg){
  total_dfs %>% 
    filter(package %in% rank_diff_pkg) %>% 
    ggplot(aes(x=year))+
    geom_line(aes(y = rank_unique, group = package), color = "red") +
    geom_line(aes(y = rank_total, group = package), color = "black") + 
    facet_wrap(~package, scale = "free") + 
    scale_y_reverse()
}