library('RPostgreSQL')
pg = dbDriver("PostgreSQL")

db_host <- Sys.getenv("DB_HOST")
db_name <- Sys.getenv("DB_NAME")
db_pass <- Sys.getenv("DB_PASS")
db_user <- Sys.getenv("DB_USER")
db_port <- Sys.getenv("DB_PORT")

con = dbConnect(
  pg,
  user = db_user,
  password = db_pass,
  host = db_host,
  port = db_port,
  dbname = db_name
)

f <- file.info(list.files("processed/", full.names = T))
f <- rownames(f)[which.max(f$mtime)]

df <- read.csv(f)

dbWriteTable(con,
             'used_cars',
             df,
             row.names = FALSE,
             overwrite = T)

print(paste(dim(df)[1], "rows inserted"))
