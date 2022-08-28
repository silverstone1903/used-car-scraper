source("codes/utils.R")
Sys.setlocale("LC_ALL", "English")

ads <- gatherer(n_pages = 10)

df_total <- df_maker(ads)

# https://stackoverflow.com/questions/4993837/r-invalid-multibyte-string#comment115155747_7125461
df_total$price <-
  str_trim(iconv(
    df_total$price,
    from = "UTF-8",
    to = "latin1",
    sub = ""
  ),
  "right")
df_total$price <-
  stri_replace_all_charclass(df_total$price, "\\p{WHITE_SPACE}", "")

df_total$km <-
  str_trim(iconv(
    df_total$km,
    from = "UTF-8",
    to = "latin1",
    sub = ""
  ), "right")
df_total$km <-
  stri_replace_all_charclass(df_total$km, "\\p{WHITE_SPACE}", "")

df_total$eng_capacity <-
  str_trim(iconv(
    df_total$eng_capacity,
    from = "UTF-8",
    to = "latin1",
    sub = ""
  ),
  "right")
df_total$eng_capacity <-
  stri_replace_all_charclass(df_total$eng_capacity, "\\p{WHITE_SPACE}", "")


df_total$insertdate <- Sys.Date()

write.csv(
  df_total,
  str_replace_all(paste0(
    "raw_data/", "carvago", "_", Sys.Date(), ".csv"
  ), "-", "_"),
  row.names = F
)
