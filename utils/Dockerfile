FROM  rocker/r-ver:4.0.5

RUN mkdir app
WORKDIR app
RUN apt-get update -y && apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev libpq-dev git
COPY pkgs.R .
RUN Rscript pkgs.R
