### missing package check
if (!requireNamespace("dplyr")) install.packages("dplyr", quiet = T)
if (!requireNamespace("rvest")) install.packages("rvest", quiet = T)
if (!requireNamespace("xml2")) install.packages("xml2", quiet = T)
if (!requireNamespace("curl")) install.packages("curl", quiet = T)
if (!requireNamespace("knitr")) install.packages("knitr", quiet = T)
if (!requireNamespace("kableExtra")) install.packages("kableExtra", quiet = T)
if (!requireNamespace("jsonlite")) install.packages("jsonlite", quiet = T)
if (!requireNamespace("magrittr")) install.packages("magrittr", quiet = T)
if (!requireNamespace("tidyverse")) install.packages("tidyverse", quiet = T)
if (!requireNamespace("RPostgreSQL")) install.packages("RPostgreSQL", quiet = T)
if (!requireNamespace("devtools")) install.packages("devtools", quiet = T)
if (!requireNamespace("remotes")) install.packages("remotes", quiet = T)
install.packages('RPostgreSQL', dependencies=TRUE, repos='http://cran.rstudio.com/', quiet = T, type = 'source')
