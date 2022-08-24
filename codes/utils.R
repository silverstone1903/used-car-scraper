suppressMessages(library(dplyr))
suppressMessages(library(tidyr))
suppressMessages(library(rvest))
suppressMessages(library(stringr))
suppressMessages(library(stringi))
suppressMessages(library(curl))

Sys.setlocale("LC_ALL", "English")


gatherer <- function(link = "https://carvago.com/cars",
                     n_pages = 1)
{
  start.time <- Sys.time()
  df_urls = data.frame()
  for (i in 1:n_pages) {
    page <-
      read_html(paste0(link, "?page=", i))
    print(paste("Page", i))
    title <-
      page %>% html_node("body") %>% html_node(xpath = '/html/body/div[1]/div/main/div[2]/div[2]/section/div/div[2]') %>% html_nodes("h6") %>%
      html_text()
    url <-
      page %>% html_node("body") %>% html_node(xpath = '/html/body/div[1]/div/main/div[2]/div[2]/section/div/div[2]') %>%  html_nodes("a")  %>%
      html_attr("href")
    id <-
      page %>% html_node("body") %>% html_node(xpath = '/html/body/div[1]/div/main/div[2]/div[2]/section/div/div[2]') %>%  html_nodes("a") %>%
      html_attr("data-gtm-impressions-id")
    urls <- data.frame(id, title, url)
    urls <-
      urls %>%  mutate(url = paste0("https://carvago.com", url))
    df_urls <- rbind(df_urls, urls)
    
  }
  end.time <- Sys.time()
  time.taken <-
    round(as.numeric(end.time - start.time, units = "secs"), 2)
  
  message(paste("Time (s):",
                time.taken, "for", n_pages * 20, "cars"))
  return(df_urls)
}

ads_to_df <- function(link)
{
  try({
    ad <-
      read_html(curl(link, handle = curl::new_handle("useragent" = "Mozilla/5.0")), options = "HUGE")
    
    brand <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[2]/div/div[1]/div[1]/div[1]/div/div/div[1]/div/div[2]/div[1]/div[2]/a') %>%
      html_text()
    mdl <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[2]/div/div[1]/div[1]/div[1]/div/div/div[1]/div/div[2]/div[2]/div[2]/a') %>%
      html_text()
    color <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[2]/div/div[1]/div[1]/div[1]/div/div/div[1]/div/div[2]/div[3]/div[2]/div') %>%
      html_text() %>%
      str_split("\\}", simplify = T, 2) %>% as.character() %>% tail(1)
    price <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[1]/div[2]/div[2]/div[1]/div/div[1]') %>% html_text()
    km <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[1]/div[2]/div[2]/div[3]/div[3]/div[1]/div[2]') %>% html_text()
    year <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[1]/div[2]/div[2]/div[3]/div[3]/div[2]/div[2]') %>% html_text()
    transmission <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[1]/div[2]/div[2]/div[3]/div[3]/div[3]/div[2]') %>% html_text()
    eng_power <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[1]/div[2]/div[2]/div[3]/div[3]/div[4]/div[2]') %>% html_text()
    eng_capacity <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[2]/div/div[1]/div[1]/div[1]/div/div/div[2]/div/div[2]/div[5]/div[2]') %>%
      html_text()
    fuel_type <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[1]/div[2]/div[2]/div[3]/div[3]/div[5]/div[2]') %>% html_text()
    consumption <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[1]/div[2]/div[2]/div[3]/div[3]/div[6]/div[2]') %>% html_text()
    drive_type <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[1]/div[2]/div[2]/div[3]/div[3]/div[7]/div[2]') %>% html_text()
    location <-
      ad %>% html_nodes(xpath = '/html/body/div[1]/div/main/section[1]/div[2]/div[2]/div[3]/div[2]/div[2]/div[2]') %>% html_text()
    
    df <- data.frame(
      brand = ifelse(length(brand) != 0, brand, NA),
      model = ifelse(length(mdl) != 0, mdl, NA),
      color = ifelse(length(color) != 0, color, NA),
      price = ifelse(length(price) != 0, price, NA),
      km = ifelse(length(km) != 0, km, NA),
      year = ifelse(length(year) != 0, year, NA),
      transmission = ifelse(length(transmission) != 0, transmission, NA),
      eng_power = ifelse(length(eng_power) != 0, eng_power, NA),
      eng_capacity = ifelse(length(eng_capacity) != 0, eng_capacity, NA),
      fuel_type = ifelse(length(fuel_type) != 0, fuel_type, NA),
      consumption = ifelse(length(consumption) != 0, consumption, NA),
      drive_type = ifelse(length(drive_type) != 0, drive_type, NA),
      location = ifelse(length(location) != 0, location, NA)
    )
  })
  return(df)
}

df_maker <- function(df)
{
  stopifnot('url' %in% colnames(df))
  start.time <- Sys.time()
  
  df_total = data.frame()
  
  
  for (i in 1:length(df$url)) {
    skip_to_next <- FALSE
    # https://stackoverflow.com/a/55937737
    tryCatch({
      # print(paste(i, "-", df$url[i]))
      tmp <- ads_to_df(df$url[i])
      tmp$link <- df$url[i]
      df_total <- bind_rows(df_total, tmp)
    }
    , error = function(e) {
      skip_to_next <<- TRUE
    })
    if (skip_to_next) {
      next
    }
  }
  
  end.time <- Sys.time()
  time.taken <-
    round(as.numeric(end.time - start.time, units = "secs"), 2)
  message(paste("Time (s):", time.taken))
  return(df_total)
}


# ads <- gatherer(n_pages = 3)
# df_total <- df_maker(ads)
