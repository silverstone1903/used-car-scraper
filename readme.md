## R Scraper for Used Cars Data 
<br>

[![Scraper](https://github.com/silverstone1903/used-car-scraper/actions/workflows/workflow.yml/badge.svg)](https://github.com/silverstone1903/used-car-scraper/actions/workflows/workflow.yml)

<br>

Uses rvest to scrape data from carvago.com daily. It is automated using Github Actions with 3 different jobs.

1. Scraper -> It scrapes data, cleans, inserts data to RDS (PostgreSQL), and writes raw and processed data to the repository.
2. Data Sync -> It syncs both raw and processed data to an S3 bucket
3. RMarkdown Reporting -> It uses concatenated raw data to report using ggplot2 and DT.


Blog post: [R ile Scraping - İkinci El Araç Verisi](https://silverstone1903.github.io/posts/2022/08/scraper-ile-ikinci-el-arac-verisi/){:target="_blank"} (in Turkish) <br>
Daily log: [link](https://silverstone1903.github.io/used-car-scraper/report/daily_report.log) <br>
Daily Report: [link](https://silverstone1903.github.io/used-car-scraper/report/report.html) <br>

#### Folder structure
```bash
+---.github
|   \---workflows
|           workflow.yml
|           
+---codes
|       analysis.R
|       df_2_db.R
|       run_all.R
|       used-car.rmd
|       utils.R
|       
+---processed
|       processed_data_y_m_d.csv
|       
+---raw_data
|       raw_data_y_m_d.csv
|       
+---report
|       daily_report.log
|       report.html
|       
+---utils
        DESCRIPTION
        Dockerfile
        pkgs.R
        

```


#### Required Packages;
```r
suppressMessages(library(dplyr))
suppressMessages(library(tidyr))
suppressMessages(library(rvest))
suppressMessages(library(stringr))
suppressMessages(library(stringi))
suppressMessages(library(curl))
suppressMessages(library(knitr))
suppressMessages(library(RPostgreSQL))
```
