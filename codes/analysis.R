suppressMessages(library(dplyr))
suppressMessages(library(tidyr))
suppressMessages(library(knitr))
suppressMessages(library(stringr))
suppressMessages(library(stringi))

Sys.setlocale("LC_ALL", "English")


f <- "report/daily_report.log"
if (file.exists(f)) {
  file.remove(f)
}

sink("report/daily_report.log",
     append = TRUE,
     split = TRUE)
cat(rep("*", 30))
cat("\n")
cat("Analyse Date:", format(Sys.Date(), '%d-%m-%Y'))
cat("\n")

files <-
  list.files(path = "raw_data/",
             pattern = "carvago_*",
             full.names = TRUE)


dfs <-
  lapply(files, function(x)
    read.csv(x, stringsAsFactors = F))
cat("Total DF:", length(dfs))
df <- do.call(bind_rows, dfs)
rm(dfs)
rm(files)

df$insertdate <- str_trim(df$insertdate)

df$insertdate <- format(as.Date(df$insertdate), "%d/%m/%Y")

df <- df %>%  mutate(km = str_replace_all(km, "km", ""))  %>%
  mutate(km = str_trim(km)) %>% mutate(km = stri_replace_all_charclass(km, "\\p{WHITE_SPACE}", ""))
df$km <- as.numeric(df$km)

df$price <- as.numeric(df$price)

df <- df %>%  mutate(year = str_split(year, "/", simplify = T)[, 2])
df$year <- as.numeric(df$year)
df <-
  df %>%  mutate(id = str_split(link, "/", simplify = T)[, 5])

df <-
  df %>% mutate(eng_power_kw = str_split(eng_power, "kW", simplify = T)[, 1]) %>%
  mutate(eng_power_hp = str_split(eng_power, "\\(", simplify = T)[, 2]) %>%
  mutate(eng_power_hp = str_split(eng_power_hp, "hp", simplify = T)[, 1]) %>% select(-eng_power)
df$eng_power_hp <- as.numeric(df$eng_power_hp)
df$eng_power_kw <- as.numeric(df$eng_power_kw)

df <-
  df %>%  mutate(eng_capacity = str_replace_all(eng_capacity, "cc", ""))  %>%
  mutate(eng_capacity = str_trim(eng_capacity)) %>%
  mutate(eng_capacity = stri_replace_all_charclass(eng_capacity, "\\p{WHITE_SPACE}", ""))

df <-
  df %>% mutate(eng_capacity = str_replace_all(eng_capacity, regex("[d+l/d+km]"), NA_character_)) %>%
  mutate(eng_capacity = str_replace_all(eng_capacity, "Euro6", NA_character_))
df$eng_capacity <- as.numeric(df$eng_capacity)

df <-
  df %>% mutate(consumption = str_replace_all(consumption, regex("[d+xd+]"), NA_character_))


df <-
  df %>%  mutate(consumption = str_split(consumption, "l|kg", simplify = T)[, 1])
df$consumption <- as.numeric(df$consumption)

df$age <- as.numeric(format(Sys.Date(), '%Y')) - df$year

df %>% distinct(id, .keep_all = T) %>% write.csv(str_replace_all(
  paste0("processed/", "carvago_processed", "_", Sys.Date(), ".csv"),
  "-",
  "_"
), row.names = F)



cat("\n")
cat(sprintf("Data Dim: %s x %s ", dim(df)[1], dim(df)[2]))
cat("\n")
cat(sprintf("Date Between: %s - %s ",
            min(df$insertdate),
            max(df$insertdate)))

cat("\n")
cat("Unique Count:", df %>% select(id) %>% n_distinct())
cat("\n")
cat("Unique ratio:",
    df %>% select(id) %>% n_distinct() / (df %>% dim())[1])
cat("\n")

kable(df %>% group_by(brand) %>% summarise("Count" = n()) %>% arrange(desc("Count")),
      format = "pipe")
kable(df %>% group_by(fuel_type) %>% summarise("Count" = n()) %>% arrange(desc("Count")),
      format = "pipe")
kable(df %>% group_by(transmission) %>% summarise("Count" = n()) %>% arrange(desc("Count")),
      format = "pipe")

kable(df %>% group_by(insertdate) %>% count(), format = "pipe")

kable(df %>% group_by(model) %>% summarise("Count" = n()) %>% arrange(desc("Count")),
      format = "pipe")

kable(df %>% group_by(year) %>% summarise("Count" = n()) %>% arrange(desc("Count")),
      format = "pipe")

kable(df %>% group_by(model) %>% summarize("Avg. Km (Model)" = mean(km, na.rm = TRUE)),
      format = "pipe")
kable(df %>% group_by(brand) %>% summarize("Avg. Km (Brand)" = mean(km, na.rm = TRUE)),
      format = "pipe")
kable(df %>% group_by(brand) %>% summarize("Avg. Age" = mean(age, na.rm = TRUE)), format = "pipe")

cat("\n")
cat(rep("*", 30))
